import 'package:dio/dio.dart';

import '../entities/ipal_checklist_draft.dart';
import '../entities/ipal_checklist_master.dart';
import '../entities/ipal_process_draft.dart';
import '../entities/ipal_process_master.dart';
import 'ipal_checklist_payload_builder.dart';
import 'ipal_process_payload_builder.dart';

class IpalLogPayloadBuilder {
  const IpalLogPayloadBuilder._();

  static Map<String, dynamic> build({
    required String action,
    required IpalChecklistTemplate checklistTemplate,
    required IpalChecklistDraft checklistDraft,
    required IpalProcessTemplate processTemplate,
    required IpalProcessDraft processDraft,
    required List<IpalProcessSection> batchSections,
  }) {
    return {
      'tanggal': checklistDraft.tanggal,
      'action': action,
      'checklist': IpalChecklistPayloadBuilder.buildChecklistPayload(
        template: checklistTemplate,
        draft: checklistDraft,
      ),
      'process': IpalProcessPayloadBuilder.buildProcessPayload(
        template: processTemplate,
        draft: processDraft,
      ),
      'batch': IpalProcessPayloadBuilder.buildBatchPayload(
        batchSections: batchSections,
        batches: processDraft.batches,
      ),
    };
  }

  static Future<FormData> buildFormData(Map<String, dynamic> payload) async {
    final fields = <MapEntry<String, dynamic>>[
      MapEntry('tanggal', payload['tanggal']),
      MapEntry('action', payload['action']),
    ];
    final files = <MapEntry<String, MultipartFile>>[];

    final checklist = Map<String, dynamic>.from(payload['checklist'] as Map);
    fields.add(MapEntry('checklist[template_id]', checklist['template_id']));

    final checklistValues = List<Map<String, dynamic>>.from(
      (checklist['values'] as List).map(
        (value) => Map<String, dynamic>.from(value as Map),
      ),
    );
    for (final indexedValue in checklistValues.indexed) {
      final index = indexedValue.$1;
      final value = indexedValue.$2;
      fields
        ..add(MapEntry('checklist[values][$index][item_id]', value['item_id']))
        ..add(MapEntry('checklist[values][$index][status]', value['status']))
        ..add(MapEntry('checklist[values][$index][note]', value['note'] ?? ''));

      final attachmentPath = value['attachment_path']?.toString();
      if (attachmentPath != null && attachmentPath.isNotEmpty) {
        files.add(
          MapEntry(
            'checklist[values][$index][attachment]',
            await MultipartFile.fromFile(attachmentPath),
          ),
        );
      }
    }

    final process = Map<String, dynamic>.from(payload['process'] as Map);
    fields.add(MapEntry('process[template_id]', process['template_id']));

    final processValues = List<Map<String, dynamic>>.from(
      (process['values'] as List).map(
        (value) => Map<String, dynamic>.from(value as Map),
      ),
    );
    for (final indexedValue in processValues.indexed) {
      final index = indexedValue.$1;
      final value = indexedValue.$2;
      fields
        ..add(MapEntry('process[values][$index][item_id]', value['item_id']))
        ..add(
          MapEntry(
            'process[values][$index][value_text]',
            value['value_text'] ?? '',
          ),
        )
        ..add(
          MapEntry(
            'process[values][$index][value_number]',
            value['value_number'] ?? '',
          ),
        )
        ..add(MapEntry('process[values][$index][note]', value['note'] ?? ''));
    }

    final batches = List<Map<String, dynamic>>.from(
      (payload['batch'] as List).map(
        (value) => Map<String, dynamic>.from(value as Map),
      ),
    );
    for (final indexedBatch in batches.indexed) {
      final batchIndex = indexedBatch.$1;
      final batch = indexedBatch.$2;
      fields.add(MapEntry('batch[$batchIndex][batch_no]', batch['batch_no']));

      final values = List<Map<String, dynamic>>.from(
        (batch['values'] as List).map(
          (value) => Map<String, dynamic>.from(value as Map),
        ),
      );
      for (final indexedValue in values.indexed) {
        final valueIndex = indexedValue.$1;
        final value = indexedValue.$2;
        fields
          ..add(
            MapEntry(
              'batch[$batchIndex][values][$valueIndex][item_id]',
              value['item_id'],
            ),
          )
          ..add(
            MapEntry(
              'batch[$batchIndex][values][$valueIndex][value_text]',
              value['value_text'] ?? '',
            ),
          )
          ..add(
            MapEntry(
              'batch[$batchIndex][values][$valueIndex][value_number]',
              value['value_number'] ?? '',
            ),
          );
      }
    }

    return FormData.fromMap({
      for (final field in fields) field.key: field.value?.toString() ?? '',
      for (final file in files) file.key: file.value,
    });
  }
}
