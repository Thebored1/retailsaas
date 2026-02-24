import 'package:flutter/foundation.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

class AuthService {
  final _db = getIt<AppDatabase>();

  // Current Logged-in User
  final ValueNotifier<User?> currentUser = ValueNotifier(null);

  Future<bool> login(String username, String password) async {
    try {
      final user =
          await (_db.select(_db.users)..where(
                (t) =>
                    t.username.equals(username) & t.password.equals(password),
              ))
              .getSingleOrNull();

      if (user != null) {
        currentUser.value = user;
        // Audit Log
        await logAction('LOGIN', details: 'User logged in');
        return true;
      }
    } catch (e) {
      print('Login Error: $e');
    }
    return false;
  }

  Future<void> logout() async {
    if (currentUser.value != null) {
      await logAction('LOGOUT', details: 'User logged out');
      currentUser.value = null;
    }
  }

  Future<void> logAction(
    String action, {
    String? tableName,
    String? recordId,
    String? details,
  }) async {
    try {
      await _db
          .into(_db.auditLogs)
          .insert(
            AuditLogsCompanion(
              id: Value(const Uuid().v4()),
              userId: Value(
                currentUser.value?.id,
              ), // Null if system/before login
              action: Value(action),
              entityType: Value(tableName),
              recordId: Value(recordId),
              details: Value(details),
              timestamp: Value(DateTime.now()),
            ),
          );
    } catch (e) {
      print('Audit Error: $e');
    }
  }

  bool isAdmin() {
    return currentUser.value?.role == 'admin';
  }
}
