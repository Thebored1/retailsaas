import 'package:drift/drift.dart';

class Products extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();

  // Foreign Keys
  TextColumn get categoryId => text()();

  TextColumn get imageUrl => text().nullable()();

  // Pricing (Default / Master Reference)
  RealColumn get mrp => real().withDefault(const Constant(0.0))();
  RealColumn get sellingPrice => real().withDefault(const Constant(0.0))();
  RealColumn get purchaseRate => real().withDefault(const Constant(0.0))();

  BoolColumn get isTaxInclusive =>
      boolean().withDefault(const Constant(true))();

  // Tax
  TextColumn get hsnCode => text()();
  RealColumn get gstRate => real()();
  RealColumn get cessRate => real().withDefault(const Constant(0.0))();
  BoolColumn get isExempt => boolean().withDefault(const Constant(false))();

  // Stocks - Moved to ProductBatches
  // RealColumn get stockQty => real()();

  BoolColumn get isInfiniteStock =>
      boolean().nullable().withDefault(const Constant(false))();
  TextColumn get uom => text()();
  RealColumn get lowStockLimit => real()();
  BoolColumn get isLooseItem => boolean().withDefault(const Constant(false))();
  BoolColumn get batchTracking =>
      boolean().withDefault(const Constant(false))();

  // Warranty (0 = No Warranty, 12 = 1 Year)
  IntColumn get warrantyMonths => integer().withDefault(const Constant(0))();

  // System
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
