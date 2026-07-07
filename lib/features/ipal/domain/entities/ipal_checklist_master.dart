import 'package:freezed_annotation/freezed_annotation.dart';

part 'ipal_checklist_master.freezed.dart';
part 'ipal_checklist_master.g.dart';

@freezed
abstract class IpalChecklistTemplate with _$IpalChecklistTemplate {
  const factory IpalChecklistTemplate({
    required int id,
    required String name,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @Default(<IpalChecklistItem>[]) List<IpalChecklistItem> items,
  }) = _IpalChecklistTemplate;

  factory IpalChecklistTemplate.fromJson(Map<String, dynamic> json) =>
      _$IpalChecklistTemplateFromJson(json);

  factory IpalChecklistTemplate.fromApiJson(Map<String, dynamic> json) {
    return IpalChecklistTemplate.fromJson({
      'id': _intValue(json['id']),
      'name': _stringValue(json['name'], fallback: 'Checklist Harian'),
      'is_active': json['is_active'] ?? true,
      'items': _listValue(
        json['items'],
      ).map(_normalizeChecklistItem).toList(growable: false),
    });
  }
}

@freezed
abstract class IpalChecklistItem with _$IpalChecklistItem {
  const factory IpalChecklistItem({
    required int id,
    @JsonKey(name: 'template_id') int? templateId,
    required String name,
    required String category,
    @JsonKey(name: 'standard_condition') String? standardCondition,
    @JsonKey(name: 'order_no') int? orderNo,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
  }) = _IpalChecklistItem;

  factory IpalChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$IpalChecklistItemFromJson(json);
}

Map<String, dynamic> _normalizeChecklistItem(Map<String, dynamic> json) {
  final id = _intValue(json['id'] ?? json['item_id']);

  return {
    'id': id,
    'template_id': _nullableIntValue(json['template_id'] ?? json['templateId']),
    'name': _stringValue(json['name'] ?? json['label'], fallback: 'Item $id'),
    'category': _stringValue(json['category'], fallback: 'Pemeriksaan'),
    'standard_condition': (json['standard_condition'] ?? json['standard'])
        ?.toString(),
    'order_no': _nullableIntValue(json['order_no'] ?? json['orderNo']),
    'is_active': json['is_active'] ?? true,
  };
}

List<Map<String, dynamic>> _listValue(Object? value) {
  if (value is! List) return const [];

  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}

int _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _nullableIntValue(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String _stringValue(Object? value, {required String fallback}) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return fallback;
  return text;
}
