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
        body: Column(
          children: <Widget>[
            TextField(
              showCursor: true,
              textCapitalization: TextCapitalization.words,
              onChanged: null,
              decoration: InputDecoration(hintText: strings.tournamentName),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
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
            ),
            Padding(
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
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ...getTeamWidgets(teamCountValue),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(strings.finish),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getTeamWidgets(int listSize) {
    return List.generate(listSize, (i) {
      return TeamCard(i + 1);
    });
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
