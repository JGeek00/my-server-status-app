// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:my_server_status/providers/app_config_provider.dart';

void showSnacbkar({
  required BuildContext context, 
  required AppConfigProvider appConfigProvider,
  required String label, 
  required Color color,
  Color? labelColor
}) async {
  if (appConfigProvider.showingSnackbar == true) {
    ScaffoldMessenger.of(context).clearSnackBars();
    await Future.delayed(const Duration(milliseconds: 500));
  }
  appConfigProvider.setShowingSnackbar(true);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        label,
        style: TextStyle(
          color: labelColor ?? Colors.white
        ),
      ),
      backgroundColor: color,
    )
  ).closed.then((value) => appConfigProvider.setShowingSnackbar(false));
}