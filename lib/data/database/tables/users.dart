import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get username => text().unique()();
  TextColumn get password => text()(); // Plain text for now as requested
  TextColumn get role => text()(); // 'admin', 'manager', 'cashier'
  TextColumn get pin => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
