import 'package:flutter/material.dart';

void snackbar(
  final BuildContext context, {
  required final String message,
  Color? messageColor,
  final String? actionLabel,
  final VoidCallback? onPressed,
  final Color? backgroundColor,
  final Color? actionLabelColor,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: messageColor != null
              ? TextStyle(
                  color: messageColor,
                )
              : null,
        ),
        backgroundColor: backgroundColor,
        action: SnackBarAction(
          label: actionLabel ?? 'Tutup',
          textColor: actionLabelColor,
          onPressed: () => onPressed?.call(),
        ),
      ),
    );
}

void snackbarSuccess(
  final BuildContext context, {
  required final String message,
  final String? actionLabel,
  final VoidCallback? onPressed,
}) {
  snackbar(
    context,
    message: message,
    messageColor: const Color(0xFF0A3622),
    actionLabel: actionLabel,
    backgroundColor: const Color(0xFFD1E7DD),
    actionLabelColor: const Color(0xFF0A3622),
    onPressed: onPressed,
  );
}

void snackbarError(
  final BuildContext context, {
  String? message,
  final String? actionLabel,
  final VoidCallback? onPressed,
}) {
  message = message?.replaceAll('DioException [bad response]:', '').trim();

  snackbar(
    context,
    message: message ?? 'Terjadi kesalahan',
    actionLabel: actionLabel,
    backgroundColor: const Color(0xFFDC3545),
    actionLabelColor: Colors.white,
    onPressed: onPressed,
  );
}

void snackbarWarning(
  final BuildContext context, {
  required final String message,
  final String? actionLabel,
  final VoidCallback? onPressed,
}) {
  snackbar(
    context,
    message: message,
    messageColor: const Color(0xFF664D03),
    actionLabel: actionLabel,
    backgroundColor: const Color(0xFFFFF3CD),
    actionLabelColor: const Color(0xFF664D03),
    onPressed: onPressed,
  );
}

void snackbarInfo(
  final BuildContext context, {
  required final String message,
  final String? actionLabel,
  final VoidCallback? onPressed,
}) {
  snackbar(
    context,
    message: message,
    messageColor: const Color(0xFF055160),
    actionLabel: actionLabel,
    backgroundColor: const Color(0xFFCFF4FC),
    actionLabelColor: const Color(0xFF055160),
    onPressed: onPressed,
  );
}
