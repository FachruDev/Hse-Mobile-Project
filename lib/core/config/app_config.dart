import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

class AppConfig {
  const AppConfig({required this.backendUrl});

  final String backendUrl;
}

@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) {
  final backendUrl = dotenv.maybeGet('BACKEND_URL')?.trim();

  return AppConfig(
    backendUrl: backendUrl?.isNotEmpty == true
        ? backendUrl!
        : 'http://127.0.0.1:8000/api',
  );
}
