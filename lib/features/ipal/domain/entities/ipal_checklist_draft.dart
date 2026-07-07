import 'package:freezed_annotation/freezed_annotation.dart';

part 'ipal_checklist_draft.freezed.dart';
part 'ipal_checklist_draft.g.dart';

@freezed
abstract class IpalChecklistDraft with _$IpalChecklistDraft {
  const factory IpalChecklistDraft({
    required String tanggal,
    required int templateId,
    @Default(<String, String>{}) Map<String, String> statuses,
    @Default(<String, String>{}) Map<String, String> notes,
    @Default(<String, String>{}) Map<String, String> attachmentPaths,
  }) = _IpalChecklistDraft;

  factory IpalChecklistDraft.fromJson(Map<String, dynamic> json) =>
      _$IpalChecklistDraftFromJson(json);
}
