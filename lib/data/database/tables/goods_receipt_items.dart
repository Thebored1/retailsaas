import 'package:drift/drift.dart';

class GoodsReceiptItems extends Table {
  TextColumn get id => text()();
  TextColumn get grnId => text()(); // Foreign key to GoodsReceipts
  TextColumn get productId => text()();
  TextColumn get productName => text()(); // Store name snapshot
  RealColumn get orderedQty =>
      real()(); // Snapshot of what was ordered at that time (obs) or ref
  RealColumn get receivedQty => real()();
  RealColumn get rejectedQty => real()();
  RealColumn get acceptedQty => real()(); // received - rejected
  RealColumn get rate => real()(); // Snapshot of rate
  RealColumn get taxRate =>
      real().withDefault(const Constant(0.0))(); // Snapshot of Tax Rate

  // UOM
  TextColumn get uom => text().nullable()();
  RealColumn get conversionFactor => real().withDefault(const Constant(1.0))();

  @override
  Set<Column> get primaryKey => {id};
}
