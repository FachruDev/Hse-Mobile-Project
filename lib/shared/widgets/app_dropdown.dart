import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../features/forms/domain/entities/form_field_definition.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    required this.controlName,
    required this.label,
    required this.options,
    super.key,
  });

  final String controlName;
  final String label;
  final List<FormSelectOption> options;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<String>(
      formControlName: controlName,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final option in options)
          DropdownMenuItem(value: option.value, child: Text(option.label)),
      ],
    );
  }
}
