import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VolumeButton extends StatelessWidget {
  const VolumeButton({@required this.volumeOn, this.onPressed});

  final bool volumeOn;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: volumeOn ? Icon(Icons.volume_up) : Icon(Icons.volume_off),
      iconSize: 64,
      color: Colors.grey,
      splashColor: Colors.greenAccent,
      onPressed: onPressed,
    );
  }
}
