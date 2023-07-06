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