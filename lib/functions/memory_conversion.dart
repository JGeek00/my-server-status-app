import 'dart:math';

String convertMemoryToGb(int value) {
  return (value/pow(1024, 3)).toStringAsFixed(2);
}

String convertMemoryToMb(double value) {
  return (value/pow(1024, 2)).toStringAsFixed(2);
}

String convertMemoryToKb(int value) {
  return (value/1024).toStringAsFixed(2);
}