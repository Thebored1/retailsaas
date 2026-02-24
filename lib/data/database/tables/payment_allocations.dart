import 'package:drift/drift.dart';

class PaymentAllocations extends Table {
  TextColumn get id => text()();
  TextColumn get paymentId => text()(); // FK to vendor_payments
  TextColumn get grnId => text()(); // FK to goods_receipts
  RealColumn get allocatedAmount => real()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
