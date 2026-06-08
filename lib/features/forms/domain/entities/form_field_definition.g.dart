// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_field_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormFieldDefinition _$FormFieldDefinitionFromJson(Map<String, dynamic> json) =>
    _FormFieldDefinition(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      inputType: _inputTypeFromJson(json['input_type'] as String?),
      standard: json['standard'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => FormSelectOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FormSelectOption>[],
    );

Map<String, dynamic> _$FormFieldDefinitionToJson(
  _FormFieldDefinition instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'input_type': _inputTypeToJson(instance.inputType),
  'standard': instance.standard,
  'is_active': instance.isActive,
  'options': instance.options,
};

_FormSelectOption _$FormSelectOptionFromJson(Map<String, dynamic> json) =>
    _FormSelectOption(
      value: json['value'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$FormSelectOptionToJson(_FormSelectOption instance) =>
    <String, dynamic>{'value': instance.value, 'label': instance.label};
