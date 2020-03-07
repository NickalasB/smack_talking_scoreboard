import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({@required this.onPressedFunction, @required this.label});

  final Function onPressedFunction;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(48, 16, 48, 16),
      child: SizedBox(
        height: 64,
        child: RaisedButton(
          color: Colors.green,
          onPressed: onPressedFunction,
          child: Text(
            label,
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
