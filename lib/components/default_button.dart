import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String hintText;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  const DefaultButton({
    super.key,
    required this.hintText,
    this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
        onPressed: onPressed,
        child: Text(
          hintText,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
