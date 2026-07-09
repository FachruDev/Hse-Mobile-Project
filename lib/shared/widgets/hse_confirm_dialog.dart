import 'package:flutter/material.dart';

import '../../color_config.dart';

Future<bool> showHseConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Lanjutkan',
  String cancelLabel = 'Batal',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: AppColors.danger)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );

  return result == true;
}
