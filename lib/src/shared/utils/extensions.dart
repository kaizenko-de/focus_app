// Extension on widget that wraps it with a Padding widget


import 'package:flutter/material.dart';
import 'package:focus/src/shared/utils/custom_exception.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

extension ContainerExtension on Widget {
  Widget reveal({Color? color = Colors.red}) {
    return Container(
      color: color,
      child: this,
    );
  }
}

extension ShowToast on BuildContext {
  void showErrorMessage(String error) {
    toastification.show(
      context: this,
      title: Text(error),
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  void showError(CustomException error) {
    final errorMessage = error.message;

    toastification.show(
      context: this,
      title: Text(errorMessage),
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  void showSuccess(String message, {String? subtitle}) {
    toastification.show(
      context: this,
      title: Text(message),
      description: subtitle != null ? Text(subtitle) : null,
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}

// Extension on String calleg elongate that returns the string 5 times
extension Elongate on String {
  String elongate() {
    return "$this$this$this$this$this";
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// Extension on DateTime to format the date
extension FormatDateTime on DateTime {
  String formatDateTime() {
    return DateFormat('dd-MM-yyyy').format(toLocal());
  }
}

/// Adds cache-busting parameters to image URLs to ensure they refresh when the image changes
String addCacheBustingToImageUrl(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) return '';
  
  final uri = Uri.parse(imageUrl);
  final queryParams = Map<String, String>.from(uri.queryParameters);
  queryParams['t'] = DateTime.now().millisecondsSinceEpoch.toString();
  
  return uri.replace(queryParameters: queryParams).toString();
}
