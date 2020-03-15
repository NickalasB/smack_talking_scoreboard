import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard/utils/strings.dart' as strings;

class FtwButton extends StatelessWidget {
  const FtwButton({this.onChanged, this.controller});

  final Function onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 64,
        height: 64,
        decoration: new BoxDecoration(
          color: Colors.yellow[500],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: TextField(
            showCursor: true,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: controller,
            decoration: InputDecoration.collapsed(hintText: strings.forTheWin),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
