import "package:flutter/material.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_analytics/observer.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [observer],
      home: Scaffold(
          appBar: AppBar(
            title: Text("Chatly"),
          ),
          body: Center(child: Text("Chatly body"))),
    );
  }
}
