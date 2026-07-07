String textValue(Object? value, {String fallback = '-'}) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  return text.isEmpty ? fallback : text;
}

Map<String, dynamic> apiDataMap(Map<String, dynamic> response) {
  final data = response['data'];
  if (data is Map) return Map<String, dynamic>.from(data);
  return response;
}

List<Map<String, dynamic>> apiRows(Map<String, dynamic> response) {
  final data = response['data'];
  if (data is List) {
    return data.whereType<Map>().map(_asStringDynamicMap).toList();
  }
  if (data is Map && data['data'] is List) {
    return (data['data'] as List)
        .whereType<Map>()
        .map(_asStringDynamicMap)
        .toList();
  }
  return const [];
}

Object? pathValue(Map<String, dynamic> source, List<String> path) {
  Object? current = source;
  for (final key in path) {
    if (current is! Map) return null;
    current = current[key];
  }
  return current;
}

Map<String, dynamic> _asStringDynamicMap(Map item) {
  return Map<String, dynamic>.from(item);
}
