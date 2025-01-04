import 'package:flutter/material.dart';

class DropdownBtn extends StatelessWidget {
  final String labelText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final Function(String? value)? onChanged;
  final String? Function(String? value)? validator;

  const DropdownBtn({
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.labelSmall,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
