import 'package:flutter/material.dart';

class FormTextfield extends StatelessWidget {
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String? value)? onChanged;
  final Function(String?)? onSaved;

  const FormTextfield({
    required this.keyboardType,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        // floatingLabelAlignment: FloatingLabelAlignment.center,
        // floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.labelLarge,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelSmall,
      ),
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
