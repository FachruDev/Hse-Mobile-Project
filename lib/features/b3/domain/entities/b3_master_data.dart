import 'package:freezed_annotation/freezed_annotation.dart';

part 'b3_master_data.freezed.dart';
part 'b3_master_data.g.dart';

@freezed
abstract class B3MasterOption with _$B3MasterOption {
  const factory B3MasterOption({
    required int id,
    required String name,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'order_no') int? orderNo,
  }) = _B3MasterOption;

  factory B3MasterOption.fromJson(Map<String, dynamic> json) =>
      _$B3MasterOptionFromJson(json);

  factory B3MasterOption.fromApiJson(Map<String, dynamic> json) {
    return B3MasterOption.fromJson({
      'id': _intValue(json['id']),
      'name': _stringValue(json['name'] ?? json['label'], fallback: 'Pilihan'),
      'is_active': json['is_active'] ?? true,
      'order_no': _nullableIntValue(json['order_no'] ?? json['orderNo']),
    });
  }
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
