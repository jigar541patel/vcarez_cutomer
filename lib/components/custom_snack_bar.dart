import 'package:flutter/material.dart';

SnackBar createMessageSnackBar(String message, {String buttonTitle = "close",int duration = 2}) {
  return SnackBar(
    content: Text(message),
    duration: Duration(seconds: duration),
    action: SnackBarAction(
      label: 'Close',
      textColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}
