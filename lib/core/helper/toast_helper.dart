import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    toastification.show(
      context: context,
      title: const Text('Success', style: TextStyle(color: Colors.green)),
      description: Text(message),
      autoCloseDuration: duration,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    toastification.show(
      context: context,
      title: const Text('Error', style: TextStyle(color: Colors.red)),
      description: Text(message),
      autoCloseDuration: duration,
      icon: const Icon(Icons.error, color: Colors.red),
    );
  }
}
