import "package:flutter/material.dart";

class MessageListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      children: List.generate(20, (i) => ListTile(title: Text("Manick $i"))),
    );
  }
}
