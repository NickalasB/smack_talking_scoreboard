import 'dart:ui';

import 'package:flutter/material.dart';

Color generateProperTeamColor(int teamNumber) {
  return teamNumber % 2 == 0 ? Colors.blue : Colors.red;
}

Color generateProperHintColor(int teamNumber) {
  return teamNumber % 2 == 0 ? Colors.grey[400] : Colors.black45;
}
