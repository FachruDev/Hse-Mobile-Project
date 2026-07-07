// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b3_master_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_B3MasterOption _$B3MasterOptionFromJson(Map<String, dynamic> json) =>
    _B3MasterOption(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isActive: json['is_active'] as bool? ?? true,
      orderNo: (json['order_no'] as num?)?.toInt(),
    );

Map<String, dynamic> _$B3MasterOptionToJson(_B3MasterOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_active': instance.isActive,
      'order_no': instance.orderNo,
    };
