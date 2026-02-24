import 'package:drift/drift.dart';

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get code => text().nullable()(); // GL Code e.g. 1000-01
  TextColumn get name => text()();
  TextColumn get type => text()(); // Asset, Liability, Equity, Income, Expense
  TextColumn get subType => text().nullable()(); // Cash, Bank, Wallet, etc.
  TextColumn get parentId =>
      text().nullable().references(Accounts, #id)(); // Hierarchical parent
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  RealColumn get currentBalance => real().withDefault(const Constant(0.0))();

  // Specific assigning?
  TextColumn get assignedUserId =>
      text().nullable()(); // For POS Registers assigned to specific users

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
