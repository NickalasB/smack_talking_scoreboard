import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:smack_talking_scoreboard/scoreboard.dart';
import 'package:smack_talking_scoreboard/team_card.dart';

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

    partition<TeamCard>(teamCards, 2).forEach((twoTeamList) {
      widgetList.add(GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          Scoreboard.id,
          arguments: [twoTeamList],
        ),
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
