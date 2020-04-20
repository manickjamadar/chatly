import 'package:cloud_firestore/cloud_firestore.dart';

DateTime timestampToDateTime(Timestamp stamp) {
  if (stamp == null) return null;
  return stamp.toDate();
}
