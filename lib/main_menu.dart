import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smack_talking_scoreboard/scoreboard.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;

class MainMenuScreen extends StatefulWidget {
  static const String id = 'main_menu';

  const MainMenuScreen();

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitDown,
//      DeviceOrientation.portraitUp,
//    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              strings.mainMenuTitle,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GameButton(strings.singleGameLabel, Colors.red),
                  ),
                  Expanded(
                    child: GameButton(strings.tournamentLabel, Colors.blue),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future navigateToNewPage(BuildContext context, Widget widgetPage) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => widgetPage));
  }
}

class GameButton extends StatelessWidget {
  const GameButton(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: RaisedButton(
        onPressed: () => Navigator.pushNamed(context, Scoreboard.id),
        elevation: 4,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 64,
            color: Colors.grey[200],
          ),
          textAlign: TextAlign.center,
        ),
        color: color,
      ),
    );
  }
}
