import 'package:drift/drift.dart';

class PurchaseOrders extends Table {
  TextColumn get id => text()();
  TextColumn get poNumber => text()();
  TextColumn get vendorId => text()(); // FK to Vendor
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get expectedDeliveryDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(
    const Constant('Draft'),
  )(); // Draft, Sent, Received, Completed
  RealColumn get totalAmount => real()();

  // GRN Link
  TextColumn get grnId => text().nullable()();
  TextColumn get grnNumber => text().nullable()();
  TextColumn get challanNumber => text().nullable()();
  TextColumn get userId => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
