import 'package:freezed_annotation/freezed_annotation.dart';

part 'b3_storage_draft.freezed.dart';
part 'b3_storage_draft.g.dart';

@freezed
abstract class B3StorageDraft with _$B3StorageDraft {
  const factory B3StorageDraft({
    required String movementDate,
    required String movementTime,
    required String movementType,
    int? wasteTypeId,
    String? wasteTypeOther,
    int? initiatorDepartmentId,
    String? initiatorDepartmentOther,
    String? initiatorUserName,
    String? weightKg,
    String? documentNumber,
    String? photoPath,
    String? note,
  }) = _B3StorageDraft;

  factory B3StorageDraft.fromJson(Map<String, dynamic> json) =>
      _$B3StorageDraftFromJson(json);
}
