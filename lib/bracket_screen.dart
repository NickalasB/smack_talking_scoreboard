import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';
import 'package:smack_talking_scoreboard/scoreboard.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;
import 'package:smack_talking_scoreboard/team_card.dart';
import 'package:smack_talking_scoreboard/ui_components/components.dart';

import 'models/winners.dart';

class BracketScreen extends StatefulWidget {
  static const String id = 'bracketScreen';

  @override
  _BracketScreenState createState() => _BracketScreenState();
}

class _BracketScreenState extends State<BracketScreen> {
  List<TeamCard> teamCards;
  List<TeamCard> winnerCards;
  List<TeamCard> loserCards;
  bool readyForNextRound = false;
  bool goToNextRound = false;
  bool tournamentOver = false;

  List<TeamCard> winnersOfLastRound = [];

  ValueNotifier<bool> shouldShuffle = ValueNotifier(false);

  @override
  void initState() {
    shouldShuffle.value = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    teamCards = ModalRoute.of(context).settings.arguments;
    winnerCards = Provider.of<Winners>(context).winners;

    loserCards = winnersOfLastRound.isEmpty
        ? teamCards.where((team) => !winnerCards.contains(team)).toList()
        : winnersOfLastRound
            .where((team) => !winnerCards.contains(team))
            .toList();

    readyForNextRound = loserCards.length == winnerCards.length;

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
          child: Column(children: [
            ..._buildBracketSeeds(teamCards, context),
            ActionButton(
                onPressedFunction: tournamentOver
                    ? () {
                        goToNextRound = false;
                        winnerCards.clear();
                        winnersOfLastRound.clear();

                        setState(() {});
                      }
                    : readyForNextRound
                        ? () {
                            winnersOfLastRound.clear();
                            winnersOfLastRound.addAll(winnerCards);
                            winnerCards.clear();
                            goToNextRound = true;

                            setState(() {});
                          }
                        : null,
                label: !tournamentOver ? strings.nextRound : strings.reset)
          ]),
        ),
      ),
    );
  }

  List<Widget> _buildBracketSeeds(
      List<TeamCard> teamCards, BuildContext context) {
    final List<Widget> widgetList = [];

    partition<TeamCard>(
            (!tournamentOver && goToNextRound) ? winnersOfLastRound : teamCards,
            2)
        .forEach((twoTeamList) {
      final ftwScore = twoTeamList.first.ftwScore;
      final numberOfRounds = twoTeamList.first.numOfRounds;

      final firstTeam = twoTeamList.first;
      final secondTeam = twoTeamList.length >= 2 ? twoTeamList[1] : null;

      tournamentOver = secondTeam == null;

      widgetList.add(GestureDetector(
        onTap: () {
          if (tournamentOver ||
              !noWinnerOrLoser(winnerCards, firstTeam, secondTeam)) {
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
                        !tournamentOver
                            ? strings.teamCardTitle(ftwScore, numberOfRounds)
                            : strings.champions,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: winnerCards.isEmpty ||
                          winnerCards.contains(firstTeam) ||
                          noWinnerOrLoser(winnerCards, firstTeam, secondTeam)
                      ? 1.0
                      : .5,
                  child: IgnorePointer(ignoring: true, child: firstTeam),
                ),
                !tournamentOver
                    ? Text(
                        strings.versus,
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                      )
                    : SizedBox.shrink(),
                Opacity(
                  opacity: winnerCards.isEmpty ||
                          winnerCards.contains(secondTeam) ||
                          noWinnerOrLoser(winnerCards, firstTeam, secondTeam)
                      ? 1.0
                      : .5,
                  child: IgnorePointer(
                      ignoring: true, child: secondTeam ?? SizedBox.shrink()),
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
      List<TeamCard> winners, TeamCard topTeam, TeamCard bottomTeam) {
    return (!winners.contains(topTeam) && !winners.contains(bottomTeam));
  }
}
