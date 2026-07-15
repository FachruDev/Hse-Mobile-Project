import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../forms/domain/entities/form_field_definition.dart';

part 'ipal_process_master.freezed.dart';
part 'ipal_process_master.g.dart';

@freezed
abstract class IpalProcessMaster with _$IpalProcessMaster {
  const factory IpalProcessMaster({
    @Default(<IpalProcessTemplate>[]) List<IpalProcessTemplate> templates,
    @Default(<IpalProcessSection>[])
    @JsonKey(name: 'batch_sections')
    List<IpalProcessSection> batchSections,
    @Default(<IpalProcessItem>[])
    @JsonKey(name: 'batch_items')
    List<IpalProcessItem> batchItems,
  }) = _IpalProcessMaster;

  factory IpalProcessMaster.fromJson(Map<String, dynamic> json) =>
      _$IpalProcessMasterFromJson(json);

  factory IpalProcessMaster.fromApiJson(Map<String, dynamic> json) {
    final templates = _listValue(
      json['templates'] ??
          json['process_templates'] ??
          json['processTemplates'] ??
          json['process'],
    );
    final batchItems = _listValue(
      json['batch_items'] ?? json['batchItems'] ?? json['batch'],
    );
    final batchSections = _listValue(
      json['batch_sections'] ??
          json['batchSections'] ??
          json['batch_processes'],
    );

    return IpalProcessMaster.fromJson({
      'templates': templates.map(_normalizeTemplate).toList(growable: false),
      'batch_sections': batchSections
          .map(_normalizeSection)
          .toList(growable: false),
      'batch_items': batchItems.map(_normalizeItem).toList(growable: false),
    });
  }
}

@freezed
abstract class IpalProcessTemplate with _$IpalProcessTemplate {
  const factory IpalProcessTemplate({
    required int id,
    required String name,
    @Default(<IpalProcessSection>[]) List<IpalProcessSection> sections,
  }) = _IpalProcessTemplate;

  factory IpalProcessTemplate.fromJson(Map<String, dynamic> json) =>
      _$IpalProcessTemplateFromJson(json);
}

@freezed
abstract class IpalProcessSection with _$IpalProcessSection {
  const factory IpalProcessSection({
    required int id,
    required String name,
    @JsonKey(name: 'order_no') int? orderNo,
    @Default(<IpalProcessItem>[]) List<IpalProcessItem> items,
  }) = _IpalProcessSection;

  factory IpalProcessSection.fromJson(Map<String, dynamic> json) =>
      _$IpalProcessSectionFromJson(json);
}

@freezed
abstract class IpalProcessItem with _$IpalProcessItem {
  const factory IpalProcessItem({
    required int id,
    required String label,
    @JsonKey(
      name: 'input_type',
      fromJson: _inputTypeFromJson,
      toJson: _inputTypeToJson,
    )
    required HseInputType inputType,
    String? code,
    String? standard,
    @Default(<FormSelectOption>[]) List<FormSelectOption> options,
    @JsonKey(name: 'order_no') int? orderNo,
  }) = _IpalProcessItem;

  factory IpalProcessItem.fromJson(Map<String, dynamic> json) =>
      _$IpalProcessItemFromJson(json);
}

HseInputType _inputTypeFromJson(String? value) => HseInputType.parse(value);

String _inputTypeToJson(HseInputType value) => value.toApiValue();

Map<String, dynamic> _normalizeTemplate(Map<String, dynamic> json) {
  return {
    'id': _intValue(json['id']),
    'name': _stringValue(json['name'] ?? json['label'], fallback: 'Template'),
    'sections': _listValue(
      json['sections'] ?? json['process_sections'] ?? json['processSections'],
    ).map(_normalizeSection).toList(growable: false),
  };
}

Map<String, dynamic> _normalizeSection(Map<String, dynamic> json) {
  return {
    'id': _intValue(json['id']),
    'name': _stringValue(json['name'] ?? json['label'], fallback: 'Bagian'),
    'order_no': _nullableIntValue(json['order_no'] ?? json['orderNo']),
    'items': _listValue(
      json['items'] ?? json['process_items'] ?? json['processItems'],
    ).map(_normalizeItem).toList(growable: false),
  };
}

Map<String, dynamic> _normalizeItem(Map<String, dynamic> json) {
  final id = _intValue(json['id'] ?? json['item_id']);

  return {
    'id': id,
    'label': _stringValue(
      json['label'] ?? json['name'] ?? json['item_name'],
      fallback: 'Item $id',
    ),
    'input_type':
        json['input_type'] ??
        json['inputtype'] ??
        json['inputType'] ??
        json['type'],
    'code': (json['code'] ?? json['slug'])?.toString(),
    'standard': (json['standard_condition'] ?? json['standard'])?.toString(),
    'options': _normalizeOptions(json),
    'order_no': _nullableIntValue(json['order_no'] ?? json['orderNo']),
  };
}

List<Map<String, dynamic>> _normalizeOptions(Map<String, dynamic> json) {
  final rawOptions =
      json['options'] ?? json['option_values'] ?? json['choices'];
  if (rawOptions is! List) return const [];

  return rawOptions
      .map((option) {
        if (option is Map) {
          final map = Map<String, dynamic>.from(option);
          final value = _stringValue(
            map['value'] ?? map['id'] ?? map['name'] ?? map['label'],
            fallback: '',
          );
          final label = _stringValue(
            map['label'] ?? map['name'] ?? value,
            fallback: value,
          );
          return {'value': value, 'label': label};
        }

        final value = option.toString();
        return {'value': value, 'label': value};
      })
      .where((option) {
        return option['value'].toString().trim().isNotEmpty;
      })
      .toList(growable: false);
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
