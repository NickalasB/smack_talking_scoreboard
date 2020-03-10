import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/strings.dart' as strings;

Color generateProperTeamColor(int teamNumber) {
  return teamNumber % 2 == 0 ? Colors.blue : Colors.red;
}

Color generateProperHintColor(int teamNumber) {
  return teamNumber % 2 == 0 ? Colors.grey[400] : Colors.black45;
}

Future<bool> onBackPressed(BuildContext context, String title) {
  return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
          content: Text(
            strings.exitDialogContent,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                strings.exitDialogNo,
                style: TextStyle(fontSize: 20),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                strings.exitDialogYes,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ) ??
      false;
}
