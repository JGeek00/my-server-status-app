// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_server_status/config/globals.dart';

void copyToClipboard({
  required String value,
  required String successMessage
}) async {
  await Clipboard.setData(
    ClipboardData(text: value)
  );
  scaffoldMessengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(successMessage),
      backgroundColor: Colors.green,
    )
  );
}