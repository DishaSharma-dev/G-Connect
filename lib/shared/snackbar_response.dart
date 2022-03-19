import 'package:flutter/material.dart';

showResponse(BuildContext context, String message, Color color) {
  var snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
    duration: const Duration(milliseconds: 3000),
    elevation: 5,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(left: 8, right: 8),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
