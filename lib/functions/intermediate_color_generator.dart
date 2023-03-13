import 'package:flutter/material.dart';

Color generateIntermediateColor(double percentage) {
  if (percentage >= 0 && percentage < 20) {
    return Color(0x0288D1);
  }
  else if (percentage >= 20 && percentage < 40) {
    return Color(0x388E3C);
  }
  else if (percentage >= 40 && percentage < 60) {
    return Color(0xFBC02D);
  }
  else if (percentage >= 60 && percentage < 80) {
    return Color(0xF57C00);
  }
  else if (percentage >= 80 && percentage <= 100) {
    return Color(0xD32F2F);
  }
  else {
    return Colors.transparent;
  }
}