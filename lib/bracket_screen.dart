import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';
import 'package:smack_talking_scoreboard/scoreboard.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;
import 'package:smack_talking_scoreboard/team_card.dart';

import 'models/winners.dart';

class BracketScreen extends StatefulWidget {
  static const String id = 'bracketScreen';

  @override
  _BracketScreenState createState() => _BracketScreenState();
}

class _BracketScreenState extends State<BracketScreen> {
  List<TeamCard> teamCards;

  ValueNotifier<bool> shouldShuffle = ValueNotifier(false);

  @override
  void initState() {
    shouldShuffle.value = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    teamCards = ModalRoute.of(context).settings.arguments;

    if (shouldShuffle.value) {
      teamCards.shuffle();
      shouldShuffle.value = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [..._buildBracketSeeds(teamCards, context)]),
        ),
      ),
    );
  }

  List<Widget> _buildBracketSeeds(
      List<TeamCard> teamCards, BuildContext context) {
    final List<Widget> widgetList = [];
    final winners = Provider.of<Winners>(context).winners;

    partition<TeamCard>(teamCards, 2).forEach((twoTeamList) {
      final ftwScore = twoTeamList.first.ftwScore;
      final numberOfRounds = twoTeamList.first.numOfRounds;

      final firstTeam = twoTeamList.first;
      final secondTeam = twoTeamList[1];

      widgetList.add(GestureDetector(
        onTap: () {
          if (!noWinnerOrLoser(winners, firstTeam, secondTeam)) {
            return null;
          }
          return Navigator.of(context).pushNamed(
            Scoreboard.id,
            arguments: [twoTeamList],
          );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.green, width: 5.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: FittedBox(
                    child: Center(
                      child: Text(
                        strings.teamCardTitle(ftwScore, numberOfRounds),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: winners.isEmpty ||
                          winners.contains(firstTeam.teamNumber) ||
                          noWinnerOrLoser(winners, firstTeam, secondTeam)
                      ? 1.0
                      : .5,
                  child: IgnorePointer(ignoring: true, child: firstTeam),
                ),
                Text(
                  strings.versus,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                Opacity(
                  opacity: winners.isEmpty ||
                          winners.contains(secondTeam.teamNumber) ||
                          noWinnerOrLoser(winners, firstTeam, secondTeam)
                      ? 1.0
                      : .5,
                  child: IgnorePointer(ignoring: true, child: secondTeam),
                ),
              ],
            ),
          ),
        ),
      ));
    });
    return widgetList;
  }

  bool noWinnerOrLoser(
      List<int> winners, TeamCard topTeam, TeamCard bottomTeam) {
    return (!winners.contains(topTeam.teamNumber) &&
        !winners.contains(bottomTeam.teamNumber));
  }
}
