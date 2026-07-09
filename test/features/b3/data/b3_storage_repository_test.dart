import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hse_mobile/core/storage/local_cache_service.dart';
import 'package:hse_mobile/features/b3/data/b3_storage_remote_data_source.dart';
import 'package:hse_mobile/features/b3/data/b3_storage_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  test('listLogs fallback ke cache saat remote gagal', () async {
    final remote = _MockB3StorageRemoteDataSource();
    final repository = B3StorageRepository(
      remoteDataSource: remote,
      masterCache: LocalCacheService(_MemoryBox()),
      draftCache: LocalCacheService(_MemoryBox()),
    );
    final response = {
      'data': [
        {'id': 1, 'tanggal': '2026-07-09'},
      ],
    };

    when(
      () => remote.listLogs(
        month: 7,
        year: 2026,
        dateFrom: null,
        dateTo: null,
        perPage: 50,
      ),
    ).thenAnswer((_) async => response);

    expect(await repository.listLogs(month: 7, year: 2026), response);

    when(
      () => remote.listLogs(
        month: 7,
        year: 2026,
        dateFrom: null,
        dateTo: null,
        perPage: 50,
      ),
    ).thenThrow(Exception('offline'));

    expect(await repository.listLogs(month: 7, year: 2026), response);
  });

  test('detailLog fallback ke cache saat remote gagal', () async {
    final remote = _MockB3StorageRemoteDataSource();
    final repository = B3StorageRepository(
      remoteDataSource: remote,
      masterCache: LocalCacheService(_MemoryBox()),
      draftCache: LocalCacheService(_MemoryBox()),
    );
    final response = {
      'data': {'id': 1, 'tanggal': '2026-07-09'},
    };

    when(() => remote.detailLog(1)).thenAnswer((_) async => response);

    expect(await repository.detailLog(1), response);

    when(() => remote.detailLog(1)).thenThrow(Exception('offline'));

    expect(await repository.detailLog(1), response);
  });
}

class _MockB3StorageRemoteDataSource extends Mock
    implements B3StorageRemoteDataSource {}

class _MemoryBox extends Fake implements Box<dynamic> {
  final _values = <dynamic, dynamic>{};

  @override
  Future<void> put(dynamic key, dynamic value) async {
    _values[key] = value;
  }

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) {
    return _values[key] ?? defaultValue;
  }

  @override
  Future<void> delete(dynamic key) async {
    _values.remove(key);
  }
}
