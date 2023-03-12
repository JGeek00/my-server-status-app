import 'package:flutter/material.dart';

Color generateIntermediateColor(double percentage) {
  if (percentage >= 0 && percentage < 20) {
    return Color(0x03A9F4);
  }
  else if (percentage >= 20 && percentage < 40) {
    return Color(0x4CAF50);
  }
  else if (percentage >= 40 && percentage < 60) {
    return Color(0xFFEB3B);
  }
  else if (percentage >= 60 && percentage < 80) {
    return Color(0xFF9800);
  }
  else if (percentage >= 80 && percentage <= 100) {
    return Color(0xF44336);
  }
  else {
    return Colors.transparent;
  }
}