import 'package:flutter/material.dart';

class PermissionDeniedDialog extends StatelessWidget {
  final VoidCallback onOpenSettings;

  const PermissionDeniedDialog({
    super.key,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Permission Denied"),
      content: const Text(
          "Storage permission is required to pick files. Do you want to open settings?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onOpenSettings(); // Trigger opening settings
          },
          child: const Text("Open Settings"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
