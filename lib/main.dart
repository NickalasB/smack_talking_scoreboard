import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/scoreboard.dart';

import 'main_menu.dart';

void main() => runApp(SmackTalkingScoreboard());

class SmackTalkingScoreboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainMenuScreen.id,
      routes: {
        MainMenuScreen.id: (context) => const MainMenuScreen(),
        Scoreboard.id: (context) => const Scoreboard(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
