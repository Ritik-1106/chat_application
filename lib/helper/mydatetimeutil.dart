import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mydatetimeutil {
  static String getFormattedOne(
      {required BuildContext context, required String time}) {
    // it expects time as integer that why i used to int.parse method
    final datatime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    // basically it will give long format datetime but i want to only time so we need to modify according to requirement
    return TimeOfDay.fromDateTime(datatime).format(context);
  }

  static String getlastMessageTime(
      {required BuildContext context, required String sent_time, bool showyear = false}) {
    final DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(sent_time));

    // current time
    DateTime now = DateTime.now();

    if (now.day == datetime.day &&
        now.month == datetime.month &&
        now.year == datetime.year) {
      return TimeOfDay.fromDateTime(datetime).format(context) + " Today";
    }
    // print('${_getMonth(datetime)}');
    return showyear ? '${datetime.day} ${_getMonth(datetime)} ${datetime.year}' : '${datetime.day} ${_getMonth(datetime)}';
  }

 

  static String getLastTimeActive(
      {required BuildContext context, required String lastactive}) {
    final int i = int.tryParse(lastactive) ?? -1;

    if (i == 1) return "Last Seen Not Available";

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime today = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (time.day == today.day &&
        time.month == today.month &&
        time.year == today.year) {
      return "last seen today at $formattedTime";
    }

    if (today.difference(time).inHours / 24.round() == 1) {
      return "last seen yesterday at $formattedTime";
    }
    String month = _getMonth(time);
    return "last seen on ${time.day} $month on $formattedTime";
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";

      default:
        return "july";
    }
  }
}
