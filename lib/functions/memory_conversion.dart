import 'dart:math';

String convertMemoryToGb(int value) {
  return (value/pow(1024, 3)).toStringAsFixed(2);
}