import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smack_talking_scoreboard/on_boarding_screen.dart';
import 'package:smack_talking_scoreboard/scoreboard_screen.dart';
import 'package:smack_talking_scoreboard/text_to_speech.dart';
import 'package:smack_talking_scoreboard/tournament_menu_screen.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

import 'firebase/base_auth.dart';

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
                          Text(
                            strings.mainMenuTitle,
                            style: TextStyle(
                                fontSize: 48, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
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
                                Expanded(
                                  child: GameButton(strings.tournamentLabel,
                                      Colors.blue, TournamentMenu.id),
                                ),
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
      padding: EdgeInsets.all(16),
      child: RaisedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => SignInDialog(routeId: routeId),
        ),
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
    final auth = Auth.of(context);

    return AlertDialog(
      title: Center(
        child: Column(
          children: [
            Text(
              strings.chooseGameMode,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            _EmailPasswordForm(auth),
            RaisedButton(
              onPressed: () async => auth.signInWithGoogle().then(
                (_) {
                  if (auth.authStatus == AuthStatus.LOGGED_IN) {
                    Navigator.pop(context, true);
                  }
                },
              ).catchError(
                (e) => print(e),
              ),
              child: const Text('Sign in with Google'),
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
  const _EmailPasswordForm(this.auth);

  final Auth auth;

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text(
              'Create an account to enable real-time online scoring',
              textAlign: TextAlign.center,
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String value) => emailValidator(value),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (String value) => passwordValidator(value),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _signInWithEmailAndPassword(widget.auth);
                }
              },
              child: const Text('Create Account'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null
                  ? ''
                  : (_success
                      ? 'Successfully signed in ' + _userEmail
                      : 'Sign in failed'),
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return 'Password cannot be blank';
    } else if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }
    return null;
  }

  String emailValidator(String value) {
    if (value.isEmpty ||
        !RegExp(r"^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$").hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword(Auth auth) async {
    final FirebaseUser user = (await auth.signUpWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
    ));
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}
