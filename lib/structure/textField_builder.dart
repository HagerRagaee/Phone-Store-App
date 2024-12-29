import 'package:flutter/material.dart';

class TextFieldBuilder extends StatelessWidget {
  TextFieldBuilder({
    super.key,
    required this.fieldName,
    required this.controller,
    required this.validator,
  });

  final String fieldName;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: fieldName == "Password" || fieldName == "Confirm Password",
      decoration: InputDecoration(
        labelText: fieldName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
