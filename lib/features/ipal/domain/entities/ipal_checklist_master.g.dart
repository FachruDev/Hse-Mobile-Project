// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_checklist_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IpalChecklistTemplate _$IpalChecklistTemplateFromJson(
  Map<String, dynamic> json,
) => _IpalChecklistTemplate(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  isActive: json['is_active'] as bool? ?? true,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => IpalChecklistItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <IpalChecklistItem>[],
);

Map<String, dynamic> _$IpalChecklistTemplateToJson(
  _IpalChecklistTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'is_active': instance.isActive,
  'items': instance.items,
};

_IpalChecklistItem _$IpalChecklistItemFromJson(Map<String, dynamic> json) =>
    _IpalChecklistItem(
      id: (json['id'] as num).toInt(),
      templateId: (json['template_id'] as num?)?.toInt(),
      name: json['name'] as String,
      category: json['category'] as String,
      standardCondition: json['standard_condition'] as String?,
      orderNo: (json['order_no'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$IpalChecklistItemToJson(_IpalChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'template_id': instance.templateId,
      'name': instance.name,
      'category': instance.category,
      'standard_condition': instance.standardCondition,
      'order_no': instance.orderNo,
      'is_active': instance.isActive,
    };
