import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smack_talking_scoreboard/scoreboard_home.dart';

class MainMenuScreen extends StatefulWidget {
  static const String id = 'main_menu';

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
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
              'SMACK TALKING SCOREBOARD',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, ScoreboardHome.id),
                    child: Text('Single Game'),
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16),
                  RaisedButton(
                    onPressed: () => null,
                    child: Text('Tournament'),
                    color: Theme.of(context).primaryColor,
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
