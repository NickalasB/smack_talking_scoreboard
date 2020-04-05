import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smack_talking_scoreboard/on_boarding_screen.dart';
import 'package:smack_talking_scoreboard/scoreboard_screen.dart';
import 'package:smack_talking_scoreboard/text_to_speech.dart';
import 'package:smack_talking_scoreboard/tournament_menu_screen.dart';
import 'package:smack_talking_scoreboard/ui_components/dialog_action_button.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

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
    Provider.of<TextToSpeech>(context).initTts();
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
                            child: IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () => Auth.of(context).signOut(),
                              color: Colors.black45,
                            ),
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
            : Navigator.pushNamed(context, routeId),
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
    @required this.routeId,
  });

  final String routeId;

  @override
  _SignInDialogState createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Column(
          children: [
            Text(
              strings.chooseGameMode,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            _EmailPasswordForm(widget.routeId),
            OutlineButton(
              onPressed: () => signInThenGoToNextScreen(
                  context, Auth.of(context).signInWithGoogle(), widget.routeId),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              child: Container(
                height: 48,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                            image: AssetImage("assets/google_logo.png"),
                            height: 35.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            strings.signInWithGoogle,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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
  const _EmailPasswordForm(this.routeId);

  final String routeId;

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
          Container(
            child: const Text(
              strings.logInModalBody,
              textAlign: TextAlign.center,
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
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
                    await _signUpWithEmailAndPassword();
                    setState(() {});
                  }
                },
                label: strings.createAccount,
                borderColor: Colors.green,
              ),
              DialogActionButton(
                onPressedFunction: () async {
                  if (_formKey.currentState.validate()) {
                    await _signInWithEmailAndPassword();
                    setState(() {});
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
    await signInThenGoToNextScreen(
      context,
      Auth.of(context).signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      ),
      widget.routeId,
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    await signInThenGoToNextScreen(
        context,
        Auth.of(context).signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        ),
        widget.routeId);
  }
}

Future<void> signInThenGoToNextScreen(
  BuildContext context,
  Future<FirebaseUser> signIn,
  String routeId,
) async {
  try {
    await signIn;
    Navigator.popAndPushNamed(context, routeId);
  } catch (e) {
    if (e is PlatformException) {
      _signInErrorText = mappedErrorCode(e.code);
    }
  }
}

String mappedErrorCode(String code) {
  switch (code) {
    case 'ERROR_WRONG_PASSWORD':
      return strings.wrongPasswordError;
    case 'ERROR_USER_NOT_FOUND':
      return strings.userNotFoundError;
    case 'ERROR_USER_DISABLED':
      return strings.disabledUserError;
    case 'ERROR_TOO_MANY_REQUESTS':
      return strings.tooManyRequestError;
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      return strings.emailInUseError;
    default:
      return strings.defaultSignInError;
  }
}
