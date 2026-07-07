class JsonStorageCodec {
  const JsonStorageCodec._();

  static Object? normalize(Object? value) {
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }

    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key.toString(): normalize(entry.value),
      };
    }

    if (value is Iterable) {
      return value.map(normalize).toList(growable: false);
    }

    final jsonValue = _tryToJson(value);
    if (jsonValue != null && !identical(jsonValue, value)) {
      return normalize(jsonValue);
    }

    return value.toString();
  }

  static Map<String, dynamic>? normalizeMap(Object? value) {
    final normalized = normalize(value);
    if (normalized is Map<String, dynamic>) return normalized;
    if (normalized is Map) return Map<String, dynamic>.from(normalized);
    return null;
  }

  static List<Map<String, dynamic>> normalizeMapList(Object? value) {
    final normalized = normalize(value);
    if (normalized is! List) return const [];

    return normalized
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  static Object? _tryToJson(Object value) {
    try {
      final json = (value as dynamic).toJson();
      return json as Object?;
    } catch (_) {
      return null;
    }
  }
}
