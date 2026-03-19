import 'package:drift/drift.dart';

class SalesBills extends Table {
  TextColumn get id => text()(); // UUID
  DateTimeColumn get date => dateTime()();
  TextColumn get customerName => text().nullable()();
  TextColumn get customerId => text().nullable()(); // NEW: Link to Customer table
  RealColumn get grandTotal => real()();
  TextColumn get paymentStatus => text()(); // PAID, PARTIAL, UNPAID
  TextColumn get userId => text().nullable()(); // Audit User

  @override
  Set<Column> get primaryKey => {id};
}
