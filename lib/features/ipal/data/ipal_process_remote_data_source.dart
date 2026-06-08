import '../../../core/network/api_client.dart';
import '../domain/entities/ipal_process_master.dart';

class IpalProcessRemoteDataSource {
  const IpalProcessRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<IpalProcessMaster> getProcessMaster() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/master/process',
    );
    final data = Map<String, dynamic>.from(response['data'] as Map);
    return IpalProcessMaster.fromApiJson(data);
  }
}
