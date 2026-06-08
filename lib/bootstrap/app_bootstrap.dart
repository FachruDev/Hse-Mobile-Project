import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/storage/hive_box_names.dart';

class AppBootstrap {
  const AppBootstrap._();

  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env', isOptional: true);
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<dynamic>(HiveBoxNames.masterData),
      Hive.openBox<dynamic>(HiveBoxNames.formDrafts),
      Hive.openBox<dynamic>(HiveBoxNames.submitQueue),
    ]);
  }
}
