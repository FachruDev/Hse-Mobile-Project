import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/forms/domain/entities/form_field_definition.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_process_draft.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_process_master.dart';
import 'package:hse_mobile/features/ipal/domain/services/ipal_process_payload_builder.dart';

void main() {
  test('buildProcessPayload memetakan number dan text sesuai kontrak API', () {
    const template = IpalProcessTemplate(
      id: 1,
      name: 'Catatan Proses',
      sections: [
        IpalProcessSection(
          id: 10,
          name: 'Penampungan Awal',
          items: [
            IpalProcessItem(
              id: 100,
              label: 'pH',
              inputType: HseInputType.number,
            ),
            IpalProcessItem(
              id: 101,
              label: 'Kondisi',
              inputType: HseInputType.text,
            ),
          ],
        ),
      ],
    );
    const draft = IpalProcessDraft(
      tanggal: '2026-06-08',
      templateId: 1,
      processValues: {'100': '7.2', '101': 'Normal'},
      processNotes: {'100': 'Stabil'},
      processAttachmentPaths: {'100': 'C:/tmp/process.jpg'},
    );

    final payload = IpalProcessPayloadBuilder.buildProcessPayload(
      template: template,
      draft: draft,
    );
    final values = payload['values'] as List<Map<String, dynamic>>;

    expect(values[0]['value_number'], 7.2);
    expect(values[0]['value_text'], isNull);
    expect(values[0]['note'], 'Stabil');
    expect(values[0]['attachment_path'], 'C:/tmp/process.jpg');
    expect(values[1]['value_number'], isNull);
    expect(values[1]['value_text'], 'Normal');
    expect(values[1]['attachment_path'], isNull);
  });

  test('buildBatchPayload mempertahankan batch_no', () {
    const batchSections = [
      IpalProcessSection(
        id: 1,
        name: 'Air limbah awal',
        items: [
          IpalProcessItem(id: 1, label: 'pH', inputType: HseInputType.number),
        ],
      ),
    ];
    const batches = [
      IpalBatchDraft(batchNo: 3, values: {'1': '6.8'}),
    ];

    final payload = IpalProcessPayloadBuilder.buildBatchPayload(
      batchSections: batchSections,
      batches: batches,
    );

    expect(payload.single['batch_no'], 3);
    expect((payload.single['values'] as List).single['value_number'], 6.8);
  });
}
