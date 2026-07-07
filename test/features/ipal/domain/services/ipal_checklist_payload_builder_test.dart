import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_checklist_draft.dart';
import 'package:hse_mobile/features/ipal/domain/entities/ipal_checklist_master.dart';
import 'package:hse_mobile/features/ipal/domain/services/ipal_checklist_payload_builder.dart';

void main() {
  test('buildChecklistPayload memetakan status dan note sesuai item aktif', () {
    const template = IpalChecklistTemplate(
      id: 7,
      name: 'Checklist Harian',
      items: [
        IpalChecklistItem(id: 10, name: 'Pompa transfer', category: 'Unit'),
        IpalChecklistItem(
          id: 11,
          name: 'Panel listrik',
          category: 'Unit',
          isActive: false,
        ),
      ],
    );
    const draft = IpalChecklistDraft(
      tanggal: '2026-06-08',
      templateId: 7,
      statuses: {'10': 'NOT_OK', '11': 'OK'},
      notes: {'10': 'Perlu dibersihkan'},
      attachmentPaths: {'10': 'C:/tmp/checklist.jpg'},
    );

    final payload = IpalChecklistPayloadBuilder.buildChecklistPayload(
      template: template,
      draft: draft,
    );
    final values = payload['values'] as List<Map<String, dynamic>>;

    expect(payload['template_id'], 7);
    expect(values, hasLength(1));
    expect(values.single['item_id'], 10);
    expect(values.single['status'], 'NOT_OK');
    expect(values.single['note'], 'Perlu dibersihkan');
    expect(values.single['attachment_path'], 'C:/tmp/checklist.jpg');
  });

  test('missingStatuses mengembalikan nama item aktif yang belum diisi', () {
    const template = IpalChecklistTemplate(
      id: 1,
      name: 'Checklist',
      items: [
        IpalChecklistItem(id: 1, name: 'Bak equalisasi', category: 'IPAL'),
        IpalChecklistItem(id: 2, name: 'Pompa dosing', category: 'IPAL'),
      ],
    );
    const draft = IpalChecklistDraft(
      tanggal: '2026-06-08',
      templateId: 1,
      statuses: {'1': 'OK'},
    );

    expect(
      IpalChecklistPayloadBuilder.missingStatuses(
        template: template,
        draft: draft,
      ),
      ['Pompa dosing'],
    );
  });
}
