import 'package:drift/drift.dart';

class DebitNoteItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dnId => text()(); // FK to DebitNote
  TextColumn get productId => text()(); // FK to Product
  TextColumn get productName => text()(); // Snapshot

  IntColumn get orderedQty => integer()();
  IntColumn get rejectedQty => integer()();
  TextColumn get reason =>
      text()(); // Dropdown value: Damaged, Expired, Wrong Item, etc.

  RealColumn get rate => real()();
  RealColumn get taxRate => real()();
}
