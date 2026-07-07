import 'package:freezed_annotation/freezed_annotation.dart';

part 'ipal_process_draft.freezed.dart';
part 'ipal_process_draft.g.dart';

@freezed
abstract class IpalProcessDraft with _$IpalProcessDraft {
  const factory IpalProcessDraft({
    required String tanggal,
    required int templateId,
    @Default(<String, String>{}) Map<String, String> processValues,
    @Default(<String, String>{}) Map<String, String> processNotes,
    @Default(<String, String>{}) Map<String, String> processAttachmentPaths,
    @Default(<IpalBatchDraft>[]) List<IpalBatchDraft> batches,
  }) = _IpalProcessDraft;

  factory IpalProcessDraft.fromJson(Map<String, dynamic> json) =>
      _$IpalProcessDraftFromJson(json);
}

@freezed
abstract class IpalBatchDraft with _$IpalBatchDraft {
  const factory IpalBatchDraft({
    required int batchNo,
    @Default(<String, String>{}) Map<String, String> values,
    @Default(<String, String>{}) Map<String, String> notes,
  }) = _IpalBatchDraft;

  factory IpalBatchDraft.fromJson(Map<String, dynamic> json) =>
      _$IpalBatchDraftFromJson(json);
}
