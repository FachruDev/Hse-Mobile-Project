import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/b3_storage_repository.dart';

part 'b3_storage_log_controller.g.dart';

@riverpod
Future<Map<String, dynamic>> b3StorageLogList(
  Ref ref, {
  required int month,
  required int year,
}) {
  return ref
      .watch(b3StorageRepositoryProvider)
      .listLogs(month: month, year: year);
}

@riverpod
Future<Map<String, dynamic>> b3StorageLogDetail(Ref ref, int logId) {
  return ref.watch(b3StorageRepositoryProvider).detailLog(logId);
}

@riverpod
Future<Uint8List> b3StorageLogPhoto(Ref ref, int logId) {
  return ref.watch(b3StorageRepositoryProvider).photoBytes(logId);
}
