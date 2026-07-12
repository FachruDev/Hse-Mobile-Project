import 'package:flutter_test/flutter_test.dart';
import 'package:hse_mobile/features/b3/domain/entities/b3_storage_draft.dart';
import 'package:hse_mobile/features/b3/domain/services/b3_storage_payload_builder.dart';

void main() {
  test(
    'validate mewajibkan pilihan master dept dan nama petugas inisiator',
    () {
      const draft = B3StorageDraft(
        movementDate: '2026-06-08',
        movementTime: '14:30',
        movementType: 'MASUK',
        weightKg: '50',
        documentNumber: 'DOC-1',
      );

      final errors = B3StoragePayloadBuilder.validate(draft);

      expect(errors, contains('Jenis limbah wajib diisi.'));
      expect(errors, contains('Dept inisiator wajib diisi.'));
      expect(errors, contains('Nama petugas dept. inisiator wajib diisi.'));
    },
  );

  test('buildFormData memetakan field multipart tanpa foto', () async {
    const draft = B3StorageDraft(
      movementDate: '2026-06-08',
      movementTime: '14:30',
      movementType: 'MASUK',
      wasteTypeId: 1,
      initiatorDepartmentId: 2,
      initiatorUserName: 'Operator QC',
      weightKg: '50',
      documentNumber: 'DOC-1',
      note: 'Masuk gudang',
    );

    final formData = await B3StoragePayloadBuilder.buildFormData(draft);
    final fields = Map.fromEntries(formData.fields);

    expect(fields['movement_date'], '2026-06-08');
    expect(fields['movement_time'], '14:30');
    expect(fields['movement_type'], 'MASUK');
    expect(fields['waste_type_id'], '1');
    expect(fields['initiator_department_id'], '2');
    expect(fields['initiator_department_other'], '');
    expect(fields['initiator_user_name'], 'Operator QC');
    expect(fields.containsKey('initiator_user_external_id'), isFalse);
    expect(fields['weight_kg'], '50');
    expect(fields['document_number'], 'DOC-1');
    expect(fields['note'], 'Masuk gudang');
    expect(formData.files, isEmpty);
  });
}
