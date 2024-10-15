import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatFileSize(int size) {
  if (size < 1024) {
    return "$size B";
  } else if (size < 1048576) {
    return "${(size / 1024).toStringAsFixed(2)} KB";
  } else {
    return "${(size / 1048576).toStringAsFixed(2)} MB";
  }
}

String formatSharedAt(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime); // Format the date
}

void showMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}

// Method to get DateTime in the desired format (with time 23:59:59)
String getFormattedDate(DateTime? expirationDate) {
  if (expirationDate == null) return "No date selected";

  // Set the time to 23:59:59 for the selected date
  DateTime finalDateTime = DateTime(
    expirationDate.year,
    expirationDate.month,
    expirationDate.day,
    23,
    59,
    59,
  );

  // Format the DateTime to ISO 8601 format (e.g., 2024-10-13T23:59:59Z)
  return DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(finalDateTime.toUtc());
}

// This function is for displaying the date in "DD/MM/YYYY" format
String getFormattedDateForDisplay(DateTime? expirationDate) {
  if (expirationDate == null) return "Select a date";

  // This will format the date for display in "DD/MM/YYYY"
  return DateFormat('dd/MM/yyyy').format(expirationDate);
}
