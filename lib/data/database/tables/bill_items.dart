import 'package:drift/drift.dart';

class BillItems extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get billId => text()(); // FK to SalesBills
  TextColumn get productId => text()(); // FK to Products

  // Snapshot details
  TextColumn get productName => text()();

  RealColumn get quantity => real()();
  RealColumn get unitPrice => real()();
  RealColumn get taxAmount => real()();
  RealColumn get totalAmount => real()();

  // Warranty
  DateTimeColumn get warrantyEndDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
