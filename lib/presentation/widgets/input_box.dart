import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputBox extends StatelessWidget {
  InputBox({
    super.key,
    required this.fieldName,
    required this.controller,
    this.drop = false,
    this.items = const [],
  });

  final String fieldName;
  final TextEditingController controller;
  final bool drop;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          fieldName,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 300,
          child: TextFormField(
            controller: controller,
            readOnly: drop, // Make it readonly for dropdown functionality
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'أدخل $fieldName',
              hintTextDirection: TextDirection.rtl,
              suffixIcon: drop
                  ? DropdownButton<String>(
                      value: controller.text.isEmpty ? null : controller.text,
                      icon: const Icon(Icons.arrow_drop_down),
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.text = value;
                        }
                      },
                      underline: Container(), // Remove underline from dropdown
                    )
                  : null,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }
}
