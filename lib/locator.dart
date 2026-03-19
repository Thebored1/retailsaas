import 'package:get_it/get_it.dart';
import 'package:retailsaas/data/database/app_database.dart';
// import 'package:retailsaas/data/database/seed_data.dart';

import 'package:retailsaas/services/auth_service.dart';
import 'package:retailsaas/services/settings_service.dart';
import 'package:retailsaas/services/sync_service.dart';
import 'package:retailsaas/services/auto_sync_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerLazySingleton<SettingsService>(() => SettingsService());
  getIt.registerLazySingleton<SyncService>(() => SyncService());
  getIt.registerLazySingleton<AutoSyncService>(() => AutoSyncService());

  // Seed Database (Safe to run multiple times, it has checks)
  // await seedDatabase(getIt<AppDatabase>());
}
