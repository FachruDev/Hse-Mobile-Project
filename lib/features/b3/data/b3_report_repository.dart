import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';

part 'b3_report_repository.g.dart';

class B3ReportRepository {
  const B3ReportRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> monthlyReport({
    required int month,
    required int year,
  }) {
    return _apiClient.get<Map<String, dynamic>>(
      '/b3-storage/monthly-report',
      queryParameters: {'month': month, 'year': year},
    );
  }

  Future<Map<String, dynamic>> approveMonthlyReport({
    required int month,
    required int year,
    required String approvalRole,
    String? note,
  }) {
    return _apiClient.post<Map<String, dynamic>>(
      '/b3-storage/monthly-report/approve',
      data: {
        'month': month,
        'year': year,
        'approval_role': approvalRole,
        'note': note,
      },
    );
  }
}

@Riverpod(keepAlive: true)
B3ReportRepository b3ReportRepository(Ref ref) {
  return B3ReportRepository(ref.watch(apiClientProvider));
}
