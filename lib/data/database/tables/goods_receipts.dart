import 'package:drift/drift.dart';

class GoodsReceipts extends Table {
  TextColumn get id => text()();
  TextColumn get poId => text()();
  TextColumn get grnNumber => text()();
  TextColumn get challanNumber => text().nullable()();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get grnDate => dateTime()();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
