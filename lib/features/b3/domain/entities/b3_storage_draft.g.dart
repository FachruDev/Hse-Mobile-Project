// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'b3_storage_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_B3StorageDraft _$B3StorageDraftFromJson(Map<String, dynamic> json) =>
    _B3StorageDraft(
      movementDate: json['movementDate'] as String,
      movementTime: json['movementTime'] as String,
      movementType: json['movementType'] as String,
      wasteTypeId: (json['wasteTypeId'] as num?)?.toInt(),
      wasteTypeOther: json['wasteTypeOther'] as String?,
      initiatorDepartmentId: (json['initiatorDepartmentId'] as num?)?.toInt(),
      initiatorDepartmentOther: json['initiatorDepartmentOther'] as String?,
      weightKg: json['weightKg'] as String?,
      documentNumber: json['documentNumber'] as String?,
      photoPath: json['photoPath'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$B3StorageDraftToJson(_B3StorageDraft instance) =>
    <String, dynamic>{
      'movementDate': instance.movementDate,
      'movementTime': instance.movementTime,
      'movementType': instance.movementType,
      'wasteTypeId': instance.wasteTypeId,
      'wasteTypeOther': instance.wasteTypeOther,
      'initiatorDepartmentId': instance.initiatorDepartmentId,
      'initiatorDepartmentOther': instance.initiatorDepartmentOther,
      'weightKg': instance.weightKg,
      'documentNumber': instance.documentNumber,
      'photoPath': instance.photoPath,
      'note': instance.note,
    };
