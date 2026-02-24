import 'package:drift/drift.dart';

class DebitNotes extends Table {
  TextColumn get id => text()();
  TextColumn get vendorId => text()(); // FK
  TextColumn get poId => text().nullable()(); // Linked PO

  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  TextColumn get reason => text()();
  TextColumn get notes => text().nullable()(); // Additional notes
  TextColumn get status => text()(); // Draft, Sent
  TextColumn get userId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
