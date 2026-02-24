import 'package:drift/drift.dart';

class GeneralLedger extends Table {
  TextColumn get id => text()(); // UUID
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // SALE, PURCHASE, ETC
  TextColumn get description => text()();
  RealColumn get debit => real().withDefault(
    const Constant(0.0),
  )(); // Outflow/Asset Increase (in some contexts)
  RealColumn get credit =>
      real().withDefault(const Constant(0.0))(); // Inflow/Asset Decrease
  TextColumn get referenceId => text().nullable()();
  TextColumn get referenceTable => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
