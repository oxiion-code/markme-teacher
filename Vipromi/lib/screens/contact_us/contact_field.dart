import 'package:flutter/material.dart';

class ContactField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? Function(String?)? validator;

  const ContactField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator:
            validator ??
            (value) => value == null || value.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
