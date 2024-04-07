import 'package:intl/intl.dart';

String convertUnixDate({
  required int date,
  bool? lineJump}) {
  final datetime = DateTime.fromMillisecondsSinceEpoch(date*1000);
  if (lineJump == true) {
    return DateFormat("yyyy-MM-dd\nhh:mm:ss").format(datetime.toLocal());
  }
  else {
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(datetime.toLocal());
  }
}

String convertSecondsToTime(int seconds) {
  int days = seconds ~/ (24 * 3600);
  seconds = seconds % (24 * 3600);
  int hours = seconds ~/ 3600;
  seconds %= 3600;
  int minutes = seconds ~/ 60;
  seconds %= 60;

  String result = '';
  if (days > 0) {
    result += '${days}d ';
  }
  if (hours > 0) {
    result += '${hours}h ';
  }
  if (minutes > 0) {
    result += '${minutes}m ';
  }
  if (seconds > 0) {
    result += '${seconds}s';
  }
  return result.trim();
}