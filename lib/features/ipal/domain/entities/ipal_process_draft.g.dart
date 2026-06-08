// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_process_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IpalProcessDraft _$IpalProcessDraftFromJson(Map<String, dynamic> json) =>
    _IpalProcessDraft(
      tanggal: json['tanggal'] as String,
      templateId: (json['templateId'] as num).toInt(),
      processValues:
          (json['processValues'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      processNotes:
          (json['processNotes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      batches:
          (json['batches'] as List<dynamic>?)
              ?.map((e) => IpalBatchDraft.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <IpalBatchDraft>[],
    );

Map<String, dynamic> _$IpalProcessDraftToJson(_IpalProcessDraft instance) =>
    <String, dynamic>{
      'tanggal': instance.tanggal,
      'templateId': instance.templateId,
      'processValues': instance.processValues,
      'processNotes': instance.processNotes,
      'batches': instance.batches,
    };

_IpalBatchDraft _$IpalBatchDraftFromJson(Map<String, dynamic> json) =>
    _IpalBatchDraft(
      batchNo: (json['batchNo'] as num).toInt(),
      values:
          (json['values'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      notes:
          (json['notes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$IpalBatchDraftToJson(_IpalBatchDraft instance) =>
    <String, dynamic>{
      'batchNo': instance.batchNo,
      'values': instance.values,
      'notes': instance.notes,
    };
