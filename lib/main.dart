import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/scoreboard_home.dart';

import 'main_menu.dart';

void main() => runApp(SmackTalkingScoreboard());

class SmackTalkingScoreboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainMenuScreen.id,
      routes: {
        MainMenuScreen.id: (context) => MainMenuScreen(),
        ScoreboardHome.id: (context) => ScoreboardHome(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
