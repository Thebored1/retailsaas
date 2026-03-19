import 'package:drift/drift.dart';

class BillItems extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get billId => text()(); // FK to SalesBills
  TextColumn get productId => text()(); // FK to Products

  // Snapshot details
  TextColumn get productName => text()();
  TextColumn get hsnCode => text().nullable()();

  RealColumn get quantity => real()();
  RealColumn get unitPrice => real()();
  
  // Tax Snapshots
  RealColumn get taxRate => real().withDefault(const Constant(0.0))();
  RealColumn get cessRate => real().withDefault(const Constant(0.0))();
  RealColumn get taxAmount => real()();
  RealColumn get totalAmount => real()();

  // Warranty
  DateTimeColumn get warrantyEndDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
