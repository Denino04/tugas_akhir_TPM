import 'package:intl/intl.dart';

class TimezoneService {
  String convertToTimezone(DateTime dateTime, String timezone) {
    switch (timezone) {
      case 'WIB':
        return formatDate(dateTime.toUtc().add(Duration(hours: 7)));
      case 'WITA':
        return formatDate(dateTime.toUtc().add(Duration(hours: 8)));
      case 'WIT':
        return formatDate(dateTime.toUtc().add(Duration(hours: 9)));
      case 'London':
        return formatDate(dateTime.toUtc().add(Duration(hours: 1)));
      case 'JST':
        return formatDate(dateTime.toUtc().add(Duration(hours: 9)));
      default:
        return formatDate(dateTime);
    }
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
