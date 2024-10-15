import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String>? onChanged;
  final bool? obsecure;
  final TextEditingController? controller;

  const DefaultTextField({
    super.key,
    required this.label,
    this.hintText,
    required this.onSaved,
    this.obsecure,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obsecure ?? false,
          onSaved: onSaved,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          ),
        ),
      ],
    );
  }
}
