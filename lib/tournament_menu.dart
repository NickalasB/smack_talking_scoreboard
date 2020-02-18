import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;
import 'package:smack_talking_scoreboard/team_card.dart';

class TournamentMenu extends StatefulWidget {
  static const String id = 'tournamentMenu';

  const TournamentMenu();

  @override
  _TournamentMenuState createState() => _TournamentMenuState();
}

class _TournamentMenuState extends State<TournamentMenu> {
  int teamCountValue = 2;
  int roundCountValue = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: OrientationBuilder(
          builder: (context, _) {
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;

            return Column(
              children: <Widget>[
                _TournamentTitle(),
//                _DropDownsAndTeamCards(teamCountValue, isLandscape),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      FractionallySizedBox(
                        widthFactor: isLandscape ? .5 : 1,
                        heightFactor: isLandscape ? 1 : .33,
                        child: Column(
                          children: <Widget>[
                            buildTeamCountDropDown(),
                            buildRoundCountDropDown(),
                          ],
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: isLandscape
                                ? Alignment.centerRight
                                : Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              widthFactor: isLandscape ? .50 : 1,
                              heightFactor: isLandscape ? 1 : .66,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(teamCountValue, (i) {
                                    return TeamCard(i + 1);
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const _FinishButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding buildRoundCountDropDown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            strings.numberOfRounds,
            style: TextStyle(fontSize: 24),
          ),
          Container(
            width: 64,
            child: DropdownButton<dynamic>(
              value: roundCountValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (dynamic newValue) {
                setState(() {
                  roundCountValue = newValue;
                });
              },
              items: getDropdownItems([1, 2, 3, 4, 5, 6]),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTeamCountDropDown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            strings.numberOfTeams,
            style: TextStyle(fontSize: 24),
          ),
          Container(
            width: 64,
            child: DropdownButton<dynamic>(
              value: teamCountValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (dynamic newValue) {
                setState(() {
                  teamCountValue = newValue;
                });
              },
              items: getDropdownItems([2, 4, 6, 8, 10, 12, 14, 16]),
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> getDropdownItems(List<dynamic> list) {
    return list.map<DropdownMenuItem<dynamic>>((dynamic value) {
      return DropdownMenuItem<dynamic>(
        value: value,
        child: Text(
          value.toString(),
          style: TextStyle(fontSize: 24),
        ),
      );
    }).toList();
  }
}

class _TournamentTitle extends StatelessWidget {
  const _TournamentTitle();

  @override
  Widget build(BuildContext context) {
    return TextField(
      showCursor: true,
      textCapitalization: TextCapitalization.words,
      onChanged: null,
      decoration: InputDecoration(hintText: strings.tournamentName),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(strings.finish),
      ),
    );
  }
}
