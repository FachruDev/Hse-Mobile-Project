import '../../../core/network/api_client.dart';
import '../domain/entities/ipal_checklist_master.dart';

class IpalChecklistRemoteDataSource {
  const IpalChecklistRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<IpalChecklistTemplate>> getChecklistTemplates() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/master/checklist',
    );
    final data = response['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map>()
        .map((item) {
          return IpalChecklistTemplate.fromApiJson(
            Map<String, dynamic>.from(item),
          );
        })
        .toList(growable: false);
  }
}
