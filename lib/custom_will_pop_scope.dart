import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWillPopScope extends StatelessWidget {
  const CustomWillPopScope({@required this.child, this.onWillPop});

  final Widget child;
  final Function onWillPop;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return child;
    } else {
      return WillPopScope(
        onWillPop: onWillPop,
        child: child,
      );
    }
  }
}
