import 'package:flutter/material.dart';

Future showMessage(BuildContext context, String title, String message) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Future<bool?> showYesNo(BuildContext context, String title, String message) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text("No"),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );
}
