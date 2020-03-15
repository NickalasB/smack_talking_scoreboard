import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpeakButton extends StatelessWidget {
  const SpeakButton({this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        width: 64,
        height: 64,
        decoration: new BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '#\$%!',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
        ),
      ),
      iconSize: 64,
      color: Colors.green,
      splashColor: Colors.greenAccent,
      onPressed: onPressed,
    );
  }
}
