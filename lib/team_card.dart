import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;

class TeamCard extends StatelessWidget {
  const TeamCard(this.teamNumber);

  final int teamNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.blueAccent[100]),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: <Widget>[
                SizedBox(height: 8),
                Text(
                  '${strings.teamNumber}$teamNumber',
                  style: TextStyle(fontSize: 24),
                ),
                TextField(
                  showCursor: true,
                  textCapitalization: TextCapitalization.words,
                  onChanged: null,
                  decoration: InputDecoration(hintText: strings.player1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.start,
                ),
                TextField(
                  showCursor: true,
                  textCapitalization: TextCapitalization.words,
                  onChanged: null,
                  decoration: InputDecoration(hintText: strings.player2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 24)
              ],
            ),
          ),
          SizedBox(height: 24)
        ],
      ),
    );
  }
}
