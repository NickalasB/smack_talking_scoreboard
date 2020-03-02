import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;
import 'package:smack_talking_scoreboard/top_level_functions.dart';

class TeamCard extends StatelessWidget {
  const TeamCard(
      {@required this.teamNumber,
      @required this.controller1,
      this.controller2});

  final int teamNumber;
  final TextEditingController controller1;
  final TextEditingController controller2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: generateProperTeamColor(teamNumber)),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: <Widget>[
                SizedBox(height: 8),
                Text(
                  '${strings.teamNumber}$teamNumber',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                  ),
                ),
                TeamCardTextField(teamNumber, strings.player1, controller1),
                SizedBox(height: 24),
                TeamCardTextField(teamNumber, strings.player2, controller2),
                SizedBox(height: 24)
              ],
            ),
          ),
          SizedBox(height: 12)
        ],
      ),
    );
  }
}

class TeamCardTextField extends StatelessWidget {
  const TeamCardTextField(this.teamNumber, this.hint, this.controller);

  final int teamNumber;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: generateProperHintColor(teamNumber),
      showCursor: true,
      textCapitalization: TextCapitalization.words,
      onChanged: (text) {},
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: generateProperHintColor(teamNumber),
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.grey[200],
      ),
      textAlign: TextAlign.start,
    );
  }
}
