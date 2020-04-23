import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smack_talking_scoreboard/bracket_screen.dart';
import 'package:smack_talking_scoreboard/firebase/base_auth.dart';
import 'package:smack_talking_scoreboard/firebase/base_cloudstore.dart';
import 'package:smack_talking_scoreboard/scoreboard_screen.dart';
import 'package:smack_talking_scoreboard/text_to_speech.dart';
import 'package:smack_talking_scoreboard/tournament_menu_screen.dart';

import 'main_menu_screen.dart';
import 'models/winners.dart';

void main() => runApp(SmackTalkingScoreboard());

class SmackTalkingScoreboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Winners>(create: (_) => Winners()),
        Provider<TextToSpeech>(create: (_) => TextToSpeech()),
        Provider<Auth>(create: (_) => Auth()),
        Provider<Cloudstore>(create: (_) => Cloudstore()),
      ],
      child: MaterialApp(
        initialRoute: MainMenuScreen.id,
        routes: {
          MainMenuScreen.id: (context) => const MainMenuScreen(),
          Scoreboard.id: (context) => const ScoreboardScreen(),
          TournamentMenu.id: (context) => const TournamentMenu(),
          BracketScreen.id: (context) => BracketScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
