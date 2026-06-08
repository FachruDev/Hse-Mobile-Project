import '../entities/ipal_process_draft.dart';
import '../entities/ipal_process_master.dart';

abstract interface class IpalProcessRepository {
  Future<IpalProcessMaster> getProcessMaster({bool forceRefresh = false});

  IpalProcessDraft? readDraft();

  Future<void> saveDraft(IpalProcessDraft draft);

  Future<void> clearDraft();
}
