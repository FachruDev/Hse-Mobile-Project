import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.fieldErrors = const {},
  });

  final String message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isValidationError => statusCode == 422 && fieldErrors.isNotEmpty;

  factory ApiException.fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final fieldErrors = _parseFieldErrors(data['errors']);
      return ApiException(
        message: _normalizeMessage(
          data['message']?.toString(),
          statusCode,
          fieldErrors,
        ),
        statusCode: statusCode,
        fieldErrors: fieldErrors,
      );
    }

    return ApiException(
      message: error.message ?? _fallbackMessage(statusCode),
      statusCode: statusCode,
    );
  }

  static Map<String, List<String>> _parseFieldErrors(Object? errors) {
    if (errors is! Map) return const {};

    return errors.map((key, value) {
      final messages = value is List
          ? value.map((item) => item.toString()).toList()
          : <String>[value.toString()];
      return MapEntry(key.toString(), messages);
    });
  }

  static String _normalizeMessage(
    String? message,
    int? statusCode,
    Map<String, List<String>> fieldErrors,
  ) {
    final rawMessage = message?.trim();
    final flattenedErrors = fieldErrors.values.expand((value) => value);
    final uploadFailed =
        rawMessage == 'validation.uploaded' ||
        flattenedErrors.any((value) => value.trim() == 'validation.uploaded');

    if (uploadFailed) {
      return 'Upload foto gagal. Kemungkinan ukuran file atau total lampiran terlalu besar. Gunakan foto yang lebih kecil lalu kirim ulang.';
    }

    if (rawMessage != null && rawMessage.isNotEmpty) return rawMessage;

    return _fallbackMessage(statusCode);
  }

  static String _fallbackMessage(int? statusCode) {
    if (statusCode == 401) {
      return 'Sesi Anda sudah berakhir. Silakan masuk kembali.';
    }
    if (statusCode == 403) {
      return 'Anda tidak memiliki akses untuk tindakan ini.';
    }
    if (statusCode == 404) {
      return 'Data tidak ditemukan.';
    }
    if (statusCode == 422) {
      return 'Data yang dikirim belum sesuai.';
    }
    if (statusCode != null && statusCode >= 500) {
      return 'Server sedang bermasalah. Coba beberapa saat lagi.';
    }
    return 'Koneksi ke server gagal.';
  }

  @override
  String toString() => message;
}
