import 'package:intl/intl.dart';

String messageDateFormatter(DateTime dateTime) {
  final dayDifference = DateTime.now().difference(dateTime).inDays;
  if (dayDifference == 0) {
    return messsageTimeFormatter(dateTime);
  } else if (dayDifference == 1) {
    return 'yesterday';
  } else if (dayDifference == -1) {
    return 'tomorrow';
  } else {
    return DateFormat("d MMM").format(dateTime);
  }
}

String messsageTimeFormatter(DateTime dateTime) {
  return DateFormat('h:m a').format(dateTime);
}
