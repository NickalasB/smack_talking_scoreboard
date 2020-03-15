import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smack_talking_scoreboard/bracket_screen.dart';
import 'package:smack_talking_scoreboard/team_card.dart';
import 'package:smack_talking_scoreboard/ui_components/action_button.dart';
import 'package:smack_talking_scoreboard/utils/ints.dart' as ints;
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;
import 'package:smack_talking_scoreboard/utils/top_level_functions.dart';

import 'models/winners.dart';
import 'utils/custom_will_pop_scope.dart';

class TournamentMenu extends StatefulWidget {
  static const String id = 'tournamentMenu';

  const TournamentMenu();

  @override
  TournamentMenuState createState() => TournamentMenuState();
}

class TournamentMenuState extends State<TournamentMenu> {
  int teamCountValue = 2;
  int roundCountValue = 1;
  int ftwValue = 7;
  String tournamentName;

  List<TeamCard> teamCards;

  @override
  Widget build(BuildContext context) {
    teamCards = List.generate(teamCountValue, (i) {
      return TeamCard(
        teamNumber: i + 1,
        controller1: TextEditingController(),
        controller2: TextEditingController(),
        numOfRounds: roundCountValue,
        ftwScore: ftwValue,
      );
    });
    return CustomWillPopScope(
      onWillPop: () => onBackPressed(context, strings.exitTournamentTitle),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: OrientationBuilder(
            builder: (context, _) {
              final isLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;

              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      maxLines: null,
                      showCursor: true,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (text) => tournamentName = text,
                      decoration:
                          InputDecoration(hintText: strings.tournamentName),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        FractionallySizedBox(
                          widthFactor: isLandscape ? .5 : 1,
                          heightFactor: isLandscape ? 1 : .33,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: TournamentDropdown(
                                  label: strings.numberOfTeams,
                                  dropDownValue: teamCountValue,
                                  onChangedFunction: setTeamCountValue,
                                  items: getDropdownItems(
                                      ints.dropdownTeamCountOptions),
                                ),
                              ),
                              Expanded(
                                child: TournamentDropdown(
                                  label: strings.numberOfRounds,
                                  dropDownValue: roundCountValue,
                                  onChangedFunction: setRoundsValue,
                                  items: getDropdownItems(
                                      ints.dropdownRoundOptions),
                                ),
                              ),
                              Expanded(
                                child: TournamentDropdown(
                                  label: strings.scoreForTheWin,
                                  dropDownValue: ftwValue,
                                  onChangedFunction: setFtwValue,
                                  items: getDropdownItems(
                                      ints.dropdownScoreOptions),
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
                                      children: teamCards,
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
                  _StartTournamentButton(tournamentName, teamCards),
                ],
              );
            },
          ),
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

  void setFtwValue(dynamic newValue) => setState(() {
        ftwValue = newValue;
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

class TournamentDropdown extends StatelessWidget {
  const TournamentDropdown({
    this.label,
    this.dropDownValue,
    this.onChangedFunction,
    this.items,
  });

  final String label;
  final int dropDownValue;
  final Function onChangedFunction;
  final List<DropdownMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
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
                  value: dropDownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 64,
                  elevation: 16,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
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
      ),
    );
  }
}

class _StartTournamentButton extends StatelessWidget {
  const _StartTournamentButton(this.tournamentName, this.teamCards);

  final List<TeamCard> teamCards;
  final String tournamentName;

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      onPressedFunction: () {
        Provider.of<Winners>(context, listen: false).winners?.clear();

        Navigator.popAndPushNamed(context, BracketScreen.id,
            arguments: [tournamentName, teamCards]);
      },
      label: strings.start,
    );
  }
}
