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

  static String getLastMessage(
      {required BuildContext context, required String sent_time}) {
    final DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(sent_time));

    // current time
    DateTime now = DateTime.now();

    if (now.day == datetime.day &&
        now.month == datetime.month &&
        now.year == datetime.year) {
      return TimeOfDay.fromDateTime(datetime).format(context);
    }
    // print('${_getMonth(datetime)}');
    return '${datetime.day} ${_getMonth(datetime)}';
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
