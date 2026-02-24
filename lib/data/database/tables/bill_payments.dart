import 'package:drift/drift.dart';
import 'sales_bills.dart';

class BillPayments extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get billId => text().references(SalesBills, #id)();
  TextColumn get paymentMode => text()(); // CASH, UPI, CARD, etc.
  RealColumn get amount => real()();
  TextColumn get referenceNo => text().nullable()();
  TextColumn get userId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
