import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppTextInput extends StatelessWidget {
  const AppTextInput({
    required this.controlName,
    required this.label,
    this.helperText,
    this.keyboardType,
    super.key,
  });

  final String controlName;
  final String label;
  final String? helperText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: controlName,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, helperText: helperText),
    );
  }
}
