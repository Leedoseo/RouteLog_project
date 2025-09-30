import 'package:flutter/material.dart';

void showInfo(BuildContext context, String msg) {
  _show(context, msg);
}

void showError(BuildContext context, String msg) {
  _show(context, msg, isError: true);
}

void _show(BuildContext context, String msg, {bool isError = false}) {
  final cs = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: isError ? cs.error : null,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      duration: const Duration(seconds: 2),
    ),
  );
}
