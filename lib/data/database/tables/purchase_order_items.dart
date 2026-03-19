import 'package:drift/drift.dart';

class PurchaseOrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get poId => text()(); // FK to PO
  TextColumn get productId => text()(); // FK to Product

  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();

  // Snapshot of item details at time of order (in case product changes)
  TextColumn get productName => text()();
  TextColumn get hsnCode => text().nullable()();

  // Tax Snapshot
  RealColumn get taxRate => real()();
  RealColumn get cessRate => real()();

  // UOM
  TextColumn get uom => text().nullable()();
  RealColumn get conversionFactor => real().withDefault(const Constant(1.0))();

  // GRN Fields
  IntColumn get receivedQuantity => integer().nullable()();
}
