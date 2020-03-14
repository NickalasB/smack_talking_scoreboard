import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smack_talking_scoreboard/bracket_screen.dart';
import 'package:smack_talking_scoreboard/scoreboard_screen.dart';
import 'package:smack_talking_scoreboard/tournament_menu_screen.dart';

import 'main_menu_screen.dart';
import 'models/winners.dart';

void main() => runApp(SmackTalkingScoreboard());

class SmackTalkingScoreboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Winners(),
      child: MaterialApp(
        initialRoute: MainMenuScreen.id,
        routes: {
          MainMenuScreen.id: (context) => const MainMenuScreen(),
          Scoreboard.id: (context) => const Scoreboard(),
          TournamentMenu.id: (context) => const TournamentMenu(),
          BracketScreen.id: (context) => BracketScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
