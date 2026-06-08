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
  bool get isValidationError => statusCode == 422 && fieldErrors.isNotEmpty;

  factory ApiException.fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      return ApiException(
        message: data['message']?.toString() ?? _fallbackMessage(statusCode),
        statusCode: statusCode,
        fieldErrors: _parseFieldErrors(data['errors']),
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
