import 'package:flutter/material.dart';

showErrorSnackBar(BuildContext context, {@required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[900],
    ),
  );
}
