import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smack_talking_scoreboard/google_sign_in_button.dart';
import 'package:smack_talking_scoreboard/on_boarding_screen.dart';
import 'package:smack_talking_scoreboard/scoreboard_screen.dart';
import 'package:smack_talking_scoreboard/text_to_speech.dart';
import 'package:smack_talking_scoreboard/tournament_menu_screen.dart';
import 'package:smack_talking_scoreboard/ui_components/dialog_action_button.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

import 'create_or_join_dialog.dart';
import 'firebase/base_auth.dart';

String _signInErrorText;

class MainMenuScreen extends StatefulWidget {
  static const String id = 'main_menu';

  const MainMenuScreen();

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  Future<SharedPreferences> _prefs;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    checkHasSeenOnBoarding();
  }

  @override
  void didChangeDependencies() {
    TextToSpeech.of(context).initTts();
    super.didChangeDependencies();
  }

  Future<bool> checkHasSeenOnBoarding() async {
    _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    return prefs.getBool('has_seen_onBoarding');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkHasSeenOnBoarding(),
      builder: ((context, AsyncSnapshot<bool> snapshot) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Text(strings.loadingText),
                    ),
                  )
                : snapshot.data == null
                    ? OnBoardingScreen(prefs)
                    : Column(
                        children: [
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SettingsButton(),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: GameButton(strings.singleGameLabel,
                                      Colors.red, Scoreboard.id),
                                ),
                                SizedBox(height: 16),
                                Expanded(
                                  child: GameButton(strings.tournamentLabel,
                                      Colors.blue, TournamentMenu.id),
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          )
                        ],
                      ),
          ),
        );
      }),
    );
  }
}

class SettingsButton extends StatefulWidget {
  const SettingsButton();

  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    final auth = Auth.of(context);

    //TODO(me): make this a future provider
    return FutureBuilder<FirebaseUser>(
        future: auth.getCurrentUser(),
        builder: (context, snapshot) {
          final isSignedIn = snapshot.hasData;

          return PopupMenuButton<SignInState>(
              icon: Icon(Icons.settings),
              onSelected: (result) {
                if (result == SignInState.signOut) {
                  auth.signOut().then((_) => setState(() {}));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => SignInDialog(),
                  ).then((_) => setState(() {}));
                }
              },
              itemBuilder: (context) {
                return <PopupMenuEntry<SignInState>>[
                  isSignedIn
                      ? PopupMenuItem<SignInState>(
                          value: SignInState.signOut,
                          child: Text(strings.signOut),
                        )
                      : const PopupMenuItem<SignInState>(
                          value: SignInState.signIn,
                          child: Text(strings.signIn),
                        ),
                ];
              });
        });
  }
}

enum SignInState {
  signIn,
  signOut,
}

class GameButton extends StatelessWidget {
  const GameButton(this.label, this.color, this.routeId);

  final String label;
  final Color color;
  final String routeId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: RaisedButton(
        onPressed: () async => await Auth.of(context).getCurrentUser() == null
            ? showDialog(
                context: context,
                builder: (context) => SignInDialog(routeId: routeId),
              )
            : showCreateOrJoinGameDialog(context, routeId),
        elevation: 4,
        child: FittedBox(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 64,
              color: Colors.grey[200],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        color: color,
      ),
    );
  }
}

class SignInDialog extends StatefulWidget {
  const SignInDialog({
    this.routeId,
  });

  final String routeId;

  @override
  _SignInDialogState createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          strings.chooseGameMode,
          style: TextStyle(fontSize: 24),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            fit: StackFit.passthrough,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    strings.logInModalBody,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  _EmailPasswordForm(widget.routeId, isLoadingNotifier),
                  GoogleSignInButton(
                    onPressed: () {
                      isLoadingNotifier.value = true;
                      return signIn(
                              context, Auth.of(context).signInWithGoogle())
                          .then((_) => Navigator.of(context).pop())
                          .then((_) => showCreateOrJoinGameDialog(
                              context, widget.routeId))
                          .then((_) {
                        setState(() => isLoadingNotifier.value = false);
                      });
                    },
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: isLoadingNotifier,
                builder: (context, bool loading, _) => loading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.popAndPushNamed(context, widget.routeId),
          child: Text(
            strings.offLine,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  const _EmailPasswordForm(this.routeId, this.isLoadingNotifier);

  final String routeId;
  final ValueNotifier<bool> isLoadingNotifier;

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signInErrorText = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: strings.email),
            validator: (String value) => emailValidator(value),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: strings.password),
            validator: (String value) => passwordValidator(value),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DialogActionButton(
                onPressedFunction: () async {
                  if (_formKey.currentState.validate()) {
                    widget.isLoadingNotifier.value = true;
                    await _signUpWithEmailAndPassword()
                        .then((_) => Navigator.of(context).pop())
                        .then((_) =>
                            showCreateOrJoinGameDialog(context, widget.routeId))
                        .then((_) => setState(
                            () => widget.isLoadingNotifier.value = false));
                  }
                },
                label: strings.createAccount,
                borderColor: Colors.green,
              ),
              DialogActionButton(
                onPressedFunction: () async {
                  if (_formKey.currentState.validate()) {
                    widget.isLoadingNotifier.value = true;
                    await _signInWithEmailAndPassword()
                        .then((_) => Navigator.of(context).pop())
                        .then((_) =>
                            showCreateOrJoinGameDialog(context, widget.routeId))
                        .then((_) => setState(
                            () => widget.isLoadingNotifier.value = false));
                  }
                },
                label: strings.signIn,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Text(
              _signInErrorText,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return strings.passwordBlankError;
    } else if (value.length < 6) {
      return strings.passwordLengthError;
    }
    return null;
  }

  String emailValidator(String value) {
    if (value.isEmpty ||
        !RegExp(r"^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$").hasMatch(value)) {
      return strings.emailError;
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailAndPassword() async {
    await signIn(
      context,
      Auth.of(context).signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    await signIn(
      context,
      Auth.of(context).signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}

Future<void> signIn(
  BuildContext context,
  Future<FirebaseUser> signInMethod,
) async {
  try {
    await signInMethod;
  } catch (e) {
    if (e is PlatformException) {
      _signInErrorText = strings.mappedErrorCode(e.code);
    }
  }
}

Future<void> showCreateOrJoinGameDialog(
    BuildContext context, String routeId) async {
  showDialog(
    context: context,
    builder: (context) => CreateOrJoinGameDialog(routeId),
    barrierDismissible: false,
  );
}
