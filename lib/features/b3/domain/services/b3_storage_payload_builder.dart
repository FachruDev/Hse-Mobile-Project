import 'package:dio/dio.dart';

import '../entities/b3_storage_draft.dart';

class B3StoragePayloadBuilder {
  const B3StoragePayloadBuilder._();

  static Future<FormData> buildFormData(B3StorageDraft draft) async {
    final fields = <MapEntry<String, String>>[
      MapEntry('movement_date', draft.movementDate),
      MapEntry('movement_time', draft.movementTime),
      MapEntry('movement_type', draft.movementType),
      MapEntry('waste_type_id', draft.wasteTypeId?.toString() ?? ''),
      MapEntry('waste_type_other', draft.wasteTypeOther ?? ''),
      MapEntry(
        'initiator_department_id',
        draft.initiatorDepartmentId?.toString() ?? '',
      ),
      MapEntry(
        'initiator_department_other',
        draft.initiatorDepartmentOther ?? '',
      ),
      MapEntry('weight_kg', draft.weightKg ?? ''),
      MapEntry('document_number', draft.documentNumber ?? ''),
      MapEntry('note', draft.note ?? ''),
    ];

    final files = <MapEntry<String, MultipartFile>>[];
    final photoPath = draft.photoPath;
    if (photoPath != null && photoPath.isNotEmpty) {
      files.add(MapEntry('photo', await MultipartFile.fromFile(photoPath)));
    }

    return FormData.fromMap({
      for (final field in fields) field.key: field.value,
      for (final file in files) file.key: file.value,
    });
  }

  static List<String> validate(B3StorageDraft draft) {
    final errors = <String>[];
    if (draft.movementDate.isEmpty) errors.add('Tanggal wajib diisi.');
    if (draft.movementTime.isEmpty) errors.add('Jam wajib diisi.');
    if (draft.movementType.isEmpty) errors.add('Jenis pergerakan wajib diisi.');
    if (draft.wasteTypeId == null &&
        (draft.wasteTypeOther == null ||
            draft.wasteTypeOther!.trim().isEmpty)) {
      errors.add('Jenis limbah wajib diisi.');
    }
    if (draft.initiatorDepartmentId == null &&
        (draft.initiatorDepartmentOther == null ||
            draft.initiatorDepartmentOther!.trim().isEmpty)) {
      errors.add('Dept inisiator wajib diisi.');
    }
    if (draft.weightKg == null || draft.weightKg!.trim().isEmpty) {
      errors.add('Berat limbah wajib diisi.');
    } else if (num.tryParse(draft.weightKg!.trim()) == null) {
      errors.add('Berat limbah harus angka.');
    }
    if (draft.documentNumber == null || draft.documentNumber!.trim().isEmpty) {
      errors.add('Nomor dokumen wajib diisi.');
    }
    return errors;
  }
}
