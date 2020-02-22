import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;
import 'package:smack_talking_scoreboard/team_card.dart';

class TournamentMenu extends StatefulWidget {
  static const String id = 'tournamentMenu';

  const TournamentMenu();

  @override
  TournamentMenuState createState() => TournamentMenuState();
}

class TournamentMenuState extends State<TournamentMenu> {
  int teamCountValue = 2;
  int roundCountValue = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: OrientationBuilder(
          builder: (context, _) {
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;

            return Column(
              children: <Widget>[
                _TournamentTitle(),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      FractionallySizedBox(
                        widthFactor: isLandscape ? .5 : 1,
                        heightFactor: isLandscape ? 1 : .33,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: TournamentDropdown(
                                label: strings.numberOfTeams,
                                teamCountValue: teamCountValue,
                                onChangedFunction: setTeamCountValue,
                                items: getDropdownItems(
                                    [2, 4, 6, 8, 10, 12, 14, 16, 32]),
                              ),
                            ),
                            Expanded(
                              child: TournamentDropdown(
                                label: strings.numberOfRounds,
                                teamCountValue: roundCountValue,
                                onChangedFunction: setRoundsValue,
                                items: getDropdownItems([1, 2, 3, 4, 5, 6]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Stack(
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
                                    children:
                                        List.generate(teamCountValue, (i) {
                                      return TeamCard(i + 1);
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  void setTeamCountValue(dynamic newValue) => setState(() {
        teamCountValue = newValue;
      });

  void setRoundsValue(dynamic newValue) => setState(() {
        roundCountValue = newValue;
      });

  List<dynamic> getDropdownItems(List<dynamic> list) {
    return list.map<DropdownMenuItem<dynamic>>((dynamic value) {
      return DropdownMenuItem<dynamic>(
        value: value,
        child: Container(
          width: 124,
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(fontSize: 48),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _TournamentTitle extends StatelessWidget {
  const _TournamentTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        maxLines: null,
        showCursor: true,
        textCapitalization: TextCapitalization.words,
        onChanged: null,
        decoration: InputDecoration(hintText: strings.tournamentName),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 64,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TournamentDropdown extends StatelessWidget {
  const TournamentDropdown({
    this.label,
    this.teamCountValue,
    this.onChangedFunction,
    this.items,
  });

  final String label;
  final int teamCountValue;
  final Function onChangedFunction;
  final List<DropdownMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 68),
            ),
            Container(
              height: 72,
              child: DropdownButton<dynamic>(
                value: teamCountValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 64,
                elevation: 16,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                underline: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                ),
                onChanged: onChangedFunction,
                items: this.items,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(48, 16, 48, 16),
      child: SizedBox(
        height: 64,
        child: RaisedButton(
          color: Colors.green,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            strings.finish,
            style: TextStyle(
                fontSize: 32,
                color: Colors.grey[200],
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
