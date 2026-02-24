import 'package:drift/drift.dart';
import 'products.dart';
import 'product_batches.dart';
import 'package:uuid/uuid.dart';

class ProductTransactions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get type => text()(); // 'Sale', 'Return', 'Adjustment'
  RealColumn get quantity => real()();
  RealColumn get price => real()();
  RealColumn get totalAmount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get orderId => text().nullable()();
  TextColumn get location => text().nullable()(); // 'RMA_BIN', 'SHOP_FLOOR'
  TextColumn get batchId => text().nullable().references(ProductBatches, #id)();
  TextColumn get userId => text().nullable()(); // Audit User
}
