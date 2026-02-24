import 'package:drift/drift.dart';

class AuditLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId =>
      text().nullable()(); // Nullable for system actions or before login
  TextColumn get action => text()(); // e.g., 'LOGIN', 'POS_SALE'
  TextColumn get entityType => text().nullable()(); // e.g., 'sales_bills'
  TextColumn get recordId => text().nullable()(); // Affected ID
  TextColumn get details => text().nullable()(); // JSON or description
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
