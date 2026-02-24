import 'package:get_it/get_it.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/data/database/seed_data.dart';

import 'package:retailsaas/services/auth_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<AuthService>(AuthService());

  // Seed Database (Safe to run multiple times, it has checks)
  await seedDatabase(getIt<AppDatabase>());
}
