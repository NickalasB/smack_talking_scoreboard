import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:smack_talking_scoreboard/scoreboard.dart';
import 'package:smack_talking_scoreboard/team_card.dart';

class BracketScreen extends StatelessWidget {
  static const String id = 'bracketScreen';

  @override
  Widget build(BuildContext context) {
    final List<TeamCard> teamCards = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [...buildBracketSeeds(teamCards, context)]),
        ),
      ),
    );
  }

  List<Widget> buildBracketSeeds(
      List<TeamCard> teamCards, BuildContext context) {
    final List<Widget> widgetList = [];

    partition<TeamCard>(teamCards, 2).forEach((twoTeamList) {
      widgetList.add(GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(Scoreboard.id, arguments: [
          [twoTeamList[0].controller1.text, twoTeamList[0].controller2.text],
          [teamCards[1].controller1.text, teamCards[1].controller2.text]
        ]),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.green, width: 5.0, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                twoTeamList[0],
                Text(
                  'VS',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                twoTeamList[1],
              ],
            ),
          ),
        ),
      ));
    });
    return widgetList;
  }
}
