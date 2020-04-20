import 'package:cloud_firestore/cloud_firestore.dart';

DateTime timestampToDateTime(Timestamp stamp) {
  return DateTime.fromMicrosecondsSinceEpoch(
      stamp.microsecondsSinceEpoch * 1000);
}
