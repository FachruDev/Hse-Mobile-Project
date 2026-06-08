import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppChecklistItem extends StatelessWidget {
  const AppChecklistItem({
    required this.controlName,
    required this.label,
    this.standard,
    super.key,
  });

  final String controlName;
  final String label;
  final String? standard;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<String>(
      formControlName: controlName,
      decoration: InputDecoration(labelText: label, helperText: standard),
      items: const [
        DropdownMenuItem(value: 'OK', child: Text('Berfungsi')),
        DropdownMenuItem(value: 'NOT_OK', child: Text('Tidak Berfungsi')),
        DropdownMenuItem(value: 'NA', child: Text('Tidak Berlaku')),
      ],
    );
  }
}
