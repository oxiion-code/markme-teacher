import 'package:flutter/material.dart';

class AppInputTextField extends StatelessWidget {
  const AppInputTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText,),
    );
  }
}
