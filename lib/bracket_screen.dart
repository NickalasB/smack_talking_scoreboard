import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/team_card.dart';

class BracketScreen extends StatelessWidget {
  static const String id = 'bracketScreen';

  @override
  Widget build(BuildContext context) {
    final List<TeamCard> teamCards = ModalRoute.of(context).settings.arguments;
    teamCards.shuffle();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: buildBracketSeeds(teamCards),
        ),
      ),
    );
  }

  List<Widget> buildBracketSeeds(List<TeamCard> teamCards) {
    final List<Widget> widgetList = [];
    final evenTeams =
        teamCards.where((card) => teamCards.indexOf(card) % 2 == 0).toList();
    final oddTeams =
        teamCards.where((card) => teamCards.indexOf(card) % 2 != 0).toList();

    final Map<List<TeamCard>, List<TeamCard>> oddEven = {evenTeams: oddTeams};

    oddEven.forEach((List<TeamCard> evenTeam, List<TeamCard> oddTeam) {
      widgetList.add(Column(
        children: <Widget>[
          evenTeam.toList()[0],
          SizedBox(height: 8),
          Text('VS'),
          SizedBox(height: 8),
          oddTeam.toList()[0],
        ],
      ));
    });

//    teamCards.map((card) {
//      widgetList.add(Column(
//        children: <Widget>[
//          teamCards[teamCards.indexOf(card)],
//          SizedBox(height: 8),
//          Text('VS'),
//          SizedBox(height: 8),
//          if (teamCards.indexOf(card) + 1 != null)
//            teamCards[teamCards.indexOf(card)],
//        ],
//      ));
//    }).toList();

    return widgetList;
  }
}
