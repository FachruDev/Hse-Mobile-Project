import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ipal_checklist_repository_impl.dart';
import '../domain/entities/ipal_checklist_master.dart';

part 'ipal_checklist_master_controller.g.dart';

@riverpod
Future<List<IpalChecklistTemplate>> ipalChecklistTemplates(Ref ref) {
  return ref.watch(ipalChecklistRepositoryProvider).getChecklistTemplates();
}
