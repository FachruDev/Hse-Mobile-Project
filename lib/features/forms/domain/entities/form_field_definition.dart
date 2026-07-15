import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_field_definition.freezed.dart';
part 'form_field_definition.g.dart';

enum HseInputType {
  text,
  number,
  option,
  decimal2,
  integer,
  durationMinutes,
  percentage,
  optionWithIntegerM3,
  dropdown,
  optionStandard,
  optionWithManual,
  checklist,
  date,
  time;

  static HseInputType parse(String? value) {
    return switch (value?.toLowerCase().trim()) {
      'number' => HseInputType.number,
      'option' => HseInputType.option,
      'decimal_2' => HseInputType.decimal2,
      'integer' => HseInputType.integer,
      'duration_minutes' => HseInputType.durationMinutes,
      'percentage' => HseInputType.percentage,
      'option_with_integer_m3' => HseInputType.optionWithIntegerM3,
      'dropdown' || 'select' => HseInputType.dropdown,
      'option_standard' => HseInputType.optionStandard,
      'option_with_manual' => HseInputType.optionWithManual,
      'checklist' || 'status' => HseInputType.checklist,
      'date' => HseInputType.date,
      'time' => HseInputType.time,
      _ => HseInputType.text,
    };
  }

  String toApiValue() => switch (this) {
    HseInputType.text => 'text',
    HseInputType.number => 'number',
    HseInputType.option => 'option',
    HseInputType.decimal2 => 'decimal_2',
    HseInputType.integer => 'integer',
    HseInputType.durationMinutes => 'duration_minutes',
    HseInputType.percentage => 'percentage',
    HseInputType.optionWithIntegerM3 => 'option_with_integer_m3',
    HseInputType.dropdown => 'dropdown',
    HseInputType.optionStandard => 'option_standard',
    HseInputType.optionWithManual => 'option_with_manual',
    HseInputType.checklist => 'checklist',
    HseInputType.date => 'date',
    HseInputType.time => 'time',
  };
}

@freezed
abstract class FormFieldDefinition with _$FormFieldDefinition {
  const factory FormFieldDefinition({
    required int id,
    required String label,
    @JsonKey(
      name: 'input_type',
      fromJson: _inputTypeFromJson,
      toJson: _inputTypeToJson,
    )
    required HseInputType inputType,
    String? standard,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @Default(<FormSelectOption>[]) List<FormSelectOption> options,
  }) = _FormFieldDefinition;

  factory FormFieldDefinition.fromJson(Map<String, dynamic> json) =>
      _$FormFieldDefinitionFromJson(json);
}

@freezed
abstract class FormSelectOption with _$FormSelectOption {
  const factory FormSelectOption({
    required String value,
    required String label,
  }) = _FormSelectOption;

  factory FormSelectOption.fromJson(Map<String, dynamic> json) =>
      _$FormSelectOptionFromJson(json);
}

HseInputType _inputTypeFromJson(String? value) => HseInputType.parse(value);

String _inputTypeToJson(HseInputType value) => value.toApiValue();
