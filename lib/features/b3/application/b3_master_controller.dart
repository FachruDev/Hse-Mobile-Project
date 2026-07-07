import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/b3_storage_repository.dart';
import '../domain/entities/b3_master_data.dart';

part 'b3_master_controller.freezed.dart';
part 'b3_master_controller.g.dart';

@freezed
abstract class B3MasterState with _$B3MasterState {
  const factory B3MasterState({
    @Default(<B3MasterOption>[]) List<B3MasterOption> wasteTypes,
    @Default(<B3MasterOption>[]) List<B3MasterOption> departments,
  }) = _B3MasterState;
}

@riverpod
Future<B3MasterState> b3Master(Ref ref) async {
  final repository = ref.watch(b3StorageRepositoryProvider);
  final results = await Future.wait([
    repository.getWasteTypes(),
    repository.getInitiatorDepartments(),
  ]);

  return B3MasterState(wasteTypes: results[0], departments: results[1]);
}
