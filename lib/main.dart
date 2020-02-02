import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smack_talking_scoreboard/scoreboard_home.dart';

void main() => runApp(SmackTalkingScoreboard());

class SmackTalkingScoreboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        resizeToAvoidBottomInset: false,
        body: ScoreboardHome(),
      ),
    );
  }
}
