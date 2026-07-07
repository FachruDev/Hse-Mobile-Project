import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/forms/domain/entities/form_field_definition.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_checklist_draft.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_checklist_master.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_process_draft.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_process_master.dart';
import 'package:hse_mobile/features/ipal/domain/services/ipal_log_payload_builder.dart';

void main() {
  test('build menggabungkan checklist, process, dan batch ke payload IPAL', () {
    const checklistTemplate = IpalChecklistTemplate(
      id: 1,
      name: 'Checklist',
      items: [IpalChecklistItem(id: 5, name: 'Pompa', category: 'Unit')],
    );
    const checklistDraft = IpalChecklistDraft(
      tanggal: '2026-06-08',
      templateId: 1,
      statuses: {'5': 'OK'},
    );
    const processTemplate = IpalProcessTemplate(
      id: 2,
      name: 'Catatan Proses',
      sections: [
        IpalProcessSection(
          id: 3,
          name: 'Outlet',
          items: [
            IpalProcessItem(id: 8, label: 'pH', inputType: HseInputType.number),
          ],
        ),
      ],
    );
    const processDraft = IpalProcessDraft(
      tanggal: '2026-06-08',
      templateId: 2,
      processValues: {'8': '7.1'},
      batches: [
        IpalBatchDraft(batchNo: 1, values: {'9': 'Jernih'}),
      ],
    );
    const batchSections = [
      IpalProcessSection(
        id: 4,
        name: 'Batch',
        items: [
          IpalProcessItem(id: 9, label: 'Visual', inputType: HseInputType.text),
        ],
      ),
    ];

    final payload = IpalLogPayloadBuilder.build(
      action: 'SUBMIT',
      checklistTemplate: checklistTemplate,
      checklistDraft: checklistDraft,
      processTemplate: processTemplate,
      processDraft: processDraft,
      batchSections: batchSections,
    );

    expect(payload['tanggal'], '2026-06-08');
    expect(payload['action'], 'SUBMIT');
    expect(payload['checklist'], isA<Map<String, dynamic>>());
    expect(payload['process'], isA<Map<String, dynamic>>());
    expect(payload['batch'], isA<List<Map<String, dynamic>>>());
  });

  test('buildFormData mengirim lampiran checklist sebagai multipart', () async {
    final tempFile = File(
      '${Directory.systemTemp.path}/checklist-${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes([1, 2, 3]);
    final processTempFile = File(
      '${Directory.systemTemp.path}/process-${DateTime.now().microsecondsSinceEpoch}.jpg',
    );
    await processTempFile.writeAsBytes([4, 5, 6]);
    addTearDown(() {
      if (tempFile.existsSync()) tempFile.deleteSync();
      if (processTempFile.existsSync()) processTempFile.deleteSync();
    });

    const checklistTemplate = IpalChecklistTemplate(
      id: 1,
      name: 'Checklist',
      items: [IpalChecklistItem(id: 5, name: 'Pompa', category: 'Unit')],
    );
    final checklistDraft = IpalChecklistDraft(
      tanggal: '2026-06-08',
      templateId: 1,
      statuses: const {'5': 'OK'},
      attachmentPaths: {'5': tempFile.path},
    );
    const processTemplate = IpalProcessTemplate(
      id: 2,
      name: 'Catatan Proses',
      sections: [
        IpalProcessSection(
          id: 3,
          name: 'Outlet',
          items: [
            IpalProcessItem(id: 8, label: 'pH', inputType: HseInputType.number),
          ],
        ),
      ],
    );
    final processDraft = IpalProcessDraft(
      tanggal: '2026-06-08',
      templateId: 2,
      processValues: const {'8': '7.1'},
      processAttachmentPaths: {'8': processTempFile.path},
    );

    final payload = IpalLogPayloadBuilder.build(
      action: 'DRAFT',
      checklistTemplate: checklistTemplate,
      checklistDraft: checklistDraft,
      processTemplate: processTemplate,
      processDraft: processDraft,
      batchSections: const [],
    );

    final formData = await IpalLogPayloadBuilder.buildFormData(payload);

    expect(
      formData.fields.any(
        (field) =>
            field.key == 'checklist[values][0][status]' && field.value == 'OK',
      ),
      isTrue,
    );
    expect(
      formData.files.map((file) => file.key),
      containsAll([
        'checklist[values][0][attachment]',
        'process[values][0][attachment]',
      ]),
    );
  });
}
