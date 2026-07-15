// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_process_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IpalProcessMaster _$IpalProcessMasterFromJson(
  Map<String, dynamic> json,
) => _IpalProcessMaster(
  templates:
      (json['templates'] as List<dynamic>?)
          ?.map((e) => IpalProcessTemplate.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <IpalProcessTemplate>[],
  batchSections:
      (json['batch_sections'] as List<dynamic>?)
          ?.map((e) => IpalProcessSection.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <IpalProcessSection>[],
  batchItems:
      (json['batch_items'] as List<dynamic>?)
          ?.map((e) => IpalProcessItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <IpalProcessItem>[],
);

Map<String, dynamic> _$IpalProcessMasterToJson(_IpalProcessMaster instance) =>
    <String, dynamic>{
      'templates': instance.templates,
      'batch_sections': instance.batchSections,
      'batch_items': instance.batchItems,
    };

_IpalProcessTemplate _$IpalProcessTemplateFromJson(Map<String, dynamic> json) =>
    _IpalProcessTemplate(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map(
                (e) => IpalProcessSection.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <IpalProcessSection>[],
    );

Map<String, dynamic> _$IpalProcessTemplateToJson(
  _IpalProcessTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'sections': instance.sections,
};

_IpalProcessSection _$IpalProcessSectionFromJson(Map<String, dynamic> json) =>
    _IpalProcessSection(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      orderNo: (json['order_no'] as num?)?.toInt(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => IpalProcessItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <IpalProcessItem>[],
    );

Map<String, dynamic> _$IpalProcessSectionToJson(_IpalProcessSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order_no': instance.orderNo,
      'items': instance.items,
    };

_IpalProcessItem _$IpalProcessItemFromJson(Map<String, dynamic> json) =>
    _IpalProcessItem(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      inputType: _inputTypeFromJson(json['input_type'] as String?),
      code: json['code'] as String?,
      standard: json['standard'] as String?,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => FormSelectOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FormSelectOption>[],
      orderNo: (json['order_no'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IpalProcessItemToJson(_IpalProcessItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'input_type': _inputTypeToJson(instance.inputType),
      'code': instance.code,
      'standard': instance.standard,
      'options': instance.options,
      'order_no': instance.orderNo,
    };
