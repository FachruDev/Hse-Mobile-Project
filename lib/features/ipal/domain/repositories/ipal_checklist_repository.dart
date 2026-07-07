import '../entities/ipal_checklist_draft.dart';
import '../entities/ipal_checklist_master.dart';

abstract interface class IpalChecklistRepository {
  Future<List<IpalChecklistTemplate>> getChecklistTemplates();

  IpalChecklistDraft? readDraft();

  Future<void> saveDraft(IpalChecklistDraft draft);

  Future<void> clearDraft();
}
