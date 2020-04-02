import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogActionButton extends StatelessWidget {
  const DialogActionButton({
    @required this.onPressedFunction,
    @required this.label,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.black,
  });

  final Function onPressedFunction;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        border: Border.all(
          color: borderColor,
          width: 4.0,
          style: BorderStyle.solid,
        ),
        color: backgroundColor,
      ),
      width: 120,
      constraints: BoxConstraints(maxWidth: 320),
      child: RaisedButton(
        color: backgroundColor,
        onPressed: onPressedFunction,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
