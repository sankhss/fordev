import 'package:flutter/material.dart';

showLoadingSpinner(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => SimpleDialog(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text('Loading', textAlign: TextAlign.center),
          ],
        ),
      ],
    ),
  );
}

hideLoadingSpinner(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
