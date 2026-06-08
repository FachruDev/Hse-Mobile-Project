import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ipal_process_repository_impl.dart';
import '../domain/entities/ipal_process_master.dart';

part 'ipal_process_master_controller.g.dart';

@riverpod
Future<IpalProcessMaster> ipalProcessMaster(Ref ref) {
  return ref.watch(ipalProcessRepositoryProvider).getProcessMaster();
}
