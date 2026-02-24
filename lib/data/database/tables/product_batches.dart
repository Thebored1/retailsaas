import 'package:drift/drift.dart';

@DataClassName('ProductBatch')
class ProductBatches extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get productId => text()(); // FK to Products

  // Pricing (Moved from Products)
  RealColumn get mrp => real()();
  RealColumn get sellingPrice => real()();
  RealColumn get purchaseRate => real()();

  // Stock
  RealColumn get stockQty => real().withDefault(const Constant(0.0))();

  // Batch Specifics
  TextColumn get batchNumber =>
      text().nullable()(); // Manual batch number if any
  DateTimeColumn get expiryDate => dateTime().nullable()();
  BoolColumn get isDamaged => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
