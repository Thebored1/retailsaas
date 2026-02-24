import 'package:drift/drift.dart';

class VendorPayments extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get vendorId => text()(); // FK to Vendor
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get mode =>
      text().withDefault(const Constant('Cash'))(); // Cash, UPI, Bank
  TextColumn get notes => text().nullable()();
  TextColumn get reference => text().nullable()(); // Cheque No, Transaction ID
  TextColumn get userId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
