import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownOptions extends StatelessWidget {
  final List<DropdownMenuItem<String>> items; // Store menu items
  final String? selectedValue;                // Selected ID
  final ValueChanged<String?> onChanged;
  final String hintText;// Callback

  const DropdownOptions({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      hint: Text(hintText) ,
      underline: Container(height: 1, color: Colors.grey),
    );
  }
}
