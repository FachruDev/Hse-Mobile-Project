// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipal_checklist_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IpalChecklistDraft _$IpalChecklistDraftFromJson(Map<String, dynamic> json) =>
    _IpalChecklistDraft(
      tanggal: json['tanggal'] as String,
      templateId: (json['templateId'] as num).toInt(),
      statuses:
          (json['statuses'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      notes:
          (json['notes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      attachmentPaths:
          (json['attachmentPaths'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$IpalChecklistDraftToJson(_IpalChecklistDraft instance) =>
    <String, dynamic>{
      'tanggal': instance.tanggal,
      'templateId': instance.templateId,
      'statuses': instance.statuses,
      'notes': instance.notes,
      'attachmentPaths': instance.attachmentPaths,
    };
