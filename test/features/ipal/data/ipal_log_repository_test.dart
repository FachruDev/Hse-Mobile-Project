import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hse_mobile/core/storage/local_cache_service.dart';
import 'package:hse_mobile/features/ipal/data/ipal_log_remote_data_source.dart';
import 'package:hse_mobile/features/ipal/data/ipal_log_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  test('listLogs fallback ke cache saat remote gagal', () async {
    final remote = _MockIpalLogRemoteDataSource();
    final repository = IpalLogRepository(
      remoteDataSource: remote,
      historyCache: LocalCacheService(_MemoryBox()),
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
    final remote = _MockIpalLogRemoteDataSource();
    final repository = IpalLogRepository(
      remoteDataSource: remote,
      historyCache: LocalCacheService(_MemoryBox()),
    );
    final response = {
      'data': {'id': 1, 'tanggal': '2026-07-09'},
    };

    when(() => remote.detailLog(1)).thenAnswer((_) async => response);

    expect(await repository.detailLog(1), response);

    when(() => remote.detailLog(1)).thenThrow(Exception('offline'));

    expect(await repository.detailLog(1), response);
  });

  test('processReferences fallback ke cache saat remote gagal', () async {
    final remote = _MockIpalLogRemoteDataSource();
    final repository = IpalLogRepository(
      remoteDataSource: remote,
      historyCache: LocalCacheService(_MemoryBox()),
    );
    final response = {
      'data': [
        {
          'code': 'water_meter',
          'previous_date': '2026-07-14',
          'previous_value': 1500,
          'unit': 'm3',
        },
      ],
    };

    when(
      () => remote.processReferences(date: '2026-07-15'),
    ).thenAnswer((_) async => response);

    expect(await repository.processReferences(date: '2026-07-15'), response);

    when(
      () => remote.processReferences(date: '2026-07-15'),
    ).thenThrow(Exception('offline'));

    expect(await repository.processReferences(date: '2026-07-15'), response);
  });
}

class _MockIpalLogRemoteDataSource extends Mock
    implements IpalLogRemoteDataSource {}

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
