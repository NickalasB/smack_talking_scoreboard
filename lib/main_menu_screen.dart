import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smack_talking_scoreboard/on_boarding_screen.dart';
import 'package:smack_talking_scoreboard/scoreboard_screen.dart';
import 'package:smack_talking_scoreboard/tournament_menu_screen.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

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
        }));
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
        onPressed: () => Navigator.pushNamed(context, routeId),
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
