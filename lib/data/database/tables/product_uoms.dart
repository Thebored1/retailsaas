import 'package:drift/drift.dart';

class ProductUoms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productId => text()(); // FK to Products
  TextColumn get uomName => text()();
  RealColumn get conversionFactor => real()();
  BoolColumn get isBase => boolean().withDefault(const Constant(false))();
  TextColumn get barcode => text().nullable()();

  // Optional: timestamp for sync/ordering
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
