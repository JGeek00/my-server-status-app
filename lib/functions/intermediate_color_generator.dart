import 'package:flutter/material.dart';

Color generateIntermediateColor(double percentage) {
  if (percentage >= 0 && percentage < 20) {
    return Colors.blue.shade700;
  }
  else if (percentage >= 20 && percentage < 40) {
    return Colors.green.shade700;
  }
  else if (percentage >= 40 && percentage < 60) {
    return Colors.yellow.shade700;
  }
  else if (percentage >= 60 && percentage < 80) {
    return Colors.orange.shade700;
  }
  else if (percentage >= 80 && percentage <= 100) {
    return Colors.red.shade700;
  }
  else {
    return Colors.transparent;
  }
}