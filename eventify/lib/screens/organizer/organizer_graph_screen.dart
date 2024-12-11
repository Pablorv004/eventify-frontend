import 'package:flutter/material.dart';

class OrganizerGraphScreen extends StatelessWidget {
  const OrganizerGraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4'].map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            // Handle change
          },
          hint: const Text('Select a category'),
        )
      ],
    );
  }
}