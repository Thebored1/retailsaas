import 'package:drift/drift.dart';

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  /// Base64-encoded WebP image stored directly in SQLite for self-contained backups.
  /// No data: prefix — just the raw base64 string.
  TextColumn get imageB64 => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
