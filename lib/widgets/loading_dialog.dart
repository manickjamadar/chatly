import "package:flutter/material.dart";

class LoadingDialog extends StatelessWidget {
  final String message;
  LoadingDialog(this.message);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 30,
            ),
            Text(message ?? 'Loading...')
          ],
        ),
      ),
    );
  }
}
