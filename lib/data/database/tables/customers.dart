import 'package:drift/drift.dart';

class Customers extends Table {
  TextColumn get id => text()(); // UUID
  IntColumn get phone => integer().unique()(); // 10-digit number
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
