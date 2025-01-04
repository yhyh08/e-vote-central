import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextfield extends StatelessWidget {
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String? value)? onChanged;
  final Function(String?)? onSaved;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const FormTextfield({
    required this.keyboardType,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.maxLines,
    this.inputFormatters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            // floatingLabelAlignment: FloatingLabelAlignment.center,
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.labelSmall,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.labelSmall,
          ),
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
