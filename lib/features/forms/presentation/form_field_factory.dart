import 'package:flutter/material.dart';

import '../../../shared/widgets/app_checklist_item.dart';
import '../../../shared/widgets/app_dropdown.dart';
import '../../../shared/widgets/app_text_input.dart';
import '../domain/entities/form_field_definition.dart';

class FormFieldFactory {
  const FormFieldFactory._();

  static Widget build({
    required FormFieldDefinition definition,
    required String controlName,
  }) {
    return switch (definition.inputType) {
      HseInputType.number || HseInputType.decimal2 => AppTextInput(
        controlName: controlName,
        label: definition.label,
        helperText: definition.standard,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
      HseInputType.integer || HseInputType.durationMinutes => AppTextInput(
        controlName: controlName,
        label: definition.label,
        helperText: definition.standard,
        keyboardType: TextInputType.number,
      ),
      HseInputType.dropdown || HseInputType.option => AppDropdown(
        controlName: controlName,
        label: definition.label,
        options: definition.options,
      ),
      HseInputType.optionStandard => AppDropdown(
        controlName: controlName,
        label: definition.label,
        options: definition.options,
      ),
      HseInputType.optionWithManual => AppDropdown(
        controlName: controlName,
        label: definition.label,
        options: definition.options,
      ),
      HseInputType.checklist => AppChecklistItem(
        controlName: controlName,
        label: definition.label,
        standard: definition.standard,
      ),
      HseInputType.date => AppTextInput(
        controlName: controlName,
        label: definition.label,
        helperText: 'Format: YYYY-MM-DD',
        keyboardType: TextInputType.datetime,
      ),
      HseInputType.time => AppTextInput(
        controlName: controlName,
        label: definition.label,
        helperText: 'Format: HH:mm',
        keyboardType: TextInputType.datetime,
      ),
      HseInputType.text => AppTextInput(
        controlName: controlName,
        label: definition.label,
        helperText: definition.standard,
      ),
    };
  }
}
