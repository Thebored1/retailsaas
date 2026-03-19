import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class ExportService {
  final AppDatabase db;

  ExportService(this.db);

  Future<void> _healLegacyRecords() async {
    // Legacy records created before the schema update might have NULLs in these new columns.
    // Drift expects a double, so it throws "Null check operator used on a null value" when mapping.
    await db.customUpdate('UPDATE bill_items SET tax_rate = 0.0 WHERE tax_rate IS NULL');
    await db.customUpdate('UPDATE bill_items SET cess_rate = 0.0 WHERE cess_rate IS NULL');
    await db.customUpdate('UPDATE goods_receipt_items SET tax_rate = 0.0 WHERE tax_rate IS NULL');
  }

  String _escapeCsv(String? value) {
    if (value == null) return '';
    String str = value.toString();
    if (str.contains(',') || str.contains('"') || str.contains('\n')) {
      str = str.replaceAll('"', '""');
      return '"$str"';
    }
    return str;
  }

  Future<String> _getExportDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    } else {
      final dir = await getDownloadsDirectory();
      return dir?.path ?? (await getApplicationDocumentsDirectory()).path;
    }
  }

  Future<String> exportGstr1(DateTime startDate, DateTime endDate) async {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    await _healLegacyRecords();

    final bills = await (db.select(db.salesBills)
          ..where((tbl) => tbl.date.isBetweenValues(start, end)))
        .get();

    final buffer = StringBuffer();
    // GSTR-1 Headers (Simplified for this scope)
    buffer.writeln('Invoice No,Invoice Date,Customer Name,GSTIN,State Code,Total Value,Taxable Value,Tax Rate,Cess Rate,Tax Amount,HSN Code');

    for (var bill in bills) {
      final items = await (db.select(db.billItems)
            ..where((tbl) => tbl.billId.equals(bill.id)))
          .get();
      
      String customerName = bill.customerName ?? 'Cash Customer';
      String gstin = '';
      String stateCode = '';

      if (bill.customerId != null) {
        final customer = await (db.select(db.customers)
              ..where((tbl) => tbl.id.equals(bill.customerId!)))
            .getSingleOrNull();
        if (customer != null) {
           gstin = customer.gstin ?? '';
           stateCode = customer.stateCode ?? '';
        }
      }

      for (var item in items) {
        buffer.write('${_escapeCsv(bill.id.split('-').first.toUpperCase())},');
        buffer.write('${_escapeCsv(DateFormat('dd-MMM-yyyy').format(bill.date))},');
        buffer.write('${_escapeCsv(customerName)},');
        buffer.write('${_escapeCsv(gstin)},');
        buffer.write('${_escapeCsv(stateCode)},');
        buffer.write('${_escapeCsv(bill.grandTotal.toStringAsFixed(2))},');
        final taxable = item.totalAmount - item.taxAmount;
        buffer.write('${_escapeCsv(taxable.toStringAsFixed(2))},');
        buffer.write('${_escapeCsv(item.taxRate.toStringAsFixed(2))},');
        buffer.write('${_escapeCsv(item.cessRate.toStringAsFixed(2))},');
        buffer.write('${_escapeCsv(item.taxAmount.toStringAsFixed(2))},');
        buffer.write('${_escapeCsv(item.hsnCode ?? "")}');
        buffer.writeln();
      }
    }

    final dirPath = await _getExportDirectory();
    final fileName = 'GSTR1_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final filePath = '$dirPath${Platform.pathSeparator}$fileName';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());
    return filePath;
  }

  Future<String> exportGstr2(DateTime startDate, DateTime endDate) async {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    await _healLegacyRecords();

    final grns = await (db.select(db.goodsReceipts)
          ..where((tbl) => tbl.createdAt.isBetweenValues(start, end)))
        .get();

    final buffer = StringBuffer();
    // GSTR-2 Headers
    buffer.writeln('GRN No,GRN Date,Challan No,Total Amount,Item Name,HSN,Qty,Rate,Taxable Value,Tax Rate');

    for (var grn in grns) {
      final items = await (db.select(db.goodsReceiptItems)
            ..where((tbl) => tbl.grnId.equals(grn.id)))
          .get();

      for (var item in items) {
        buffer.write('${_escapeCsv(grn.grnNumber)},');
        buffer.write('${_escapeCsv(DateFormat('dd-MMM-yyyy').format(grn.createdAt))},');
        buffer.write('${_escapeCsv(grn.challanNumber)},');
        buffer.write('${_escapeCsv(grn.totalAmount.toStringAsFixed(2))},');
        buffer.write('${_escapeCsv(item.productName)},');
        buffer.write('${_escapeCsv(item.hsnCode ?? "")},');
        buffer.write('${_escapeCsv(item.receivedQty.toString())},');
        buffer.write('${_escapeCsv(item.rate.toStringAsFixed(2))},');
        final taxable = item.receivedQty * item.rate;
        buffer.write('${_escapeCsv(taxable.toStringAsFixed(2))},');
        buffer.write('${_escapeCsv(item.taxRate.toStringAsFixed(2))}');
        buffer.writeln();
      }
    }

    final dirPath = await _getExportDirectory();
    final fileName = 'GSTR2_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final filePath = '$dirPath${Platform.pathSeparator}$fileName';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());
    return filePath;
  }

  Future<String> exportEwayBill(DateTime startDate, DateTime endDate) async {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    await _healLegacyRecords();

    final bills = await (db.select(db.salesBills)
          ..where((tbl) => tbl.date.isBetweenValues(start, end))
          ..where((tbl) => tbl.grandTotal.isBiggerOrEqualValue(50000.0)))
        .get();

    final buffer = StringBuffer();
    // E-Way Bill Headers
    buffer.writeln('Supply Type,Sub Type,Doc Type,Doc No,Doc Date,From State Code,From Pin,To State Code,To Pin,To GSTIN,Product Name,HSN,Qty,UOM,Taxable Value,Tax Rate,Cess Rate');

    for (var bill in bills) {
      final items = await (db.select(db.billItems)
            ..where((tbl) => tbl.billId.equals(bill.id)))
          .get();
      
      String toGstin = 'URP';
      String toStateCode = '';
      String toPin = '';

      if (bill.customerId != null) {
        final customer = await (db.select(db.customers)
              ..where((tbl) => tbl.id.equals(bill.customerId!)))
            .getSingleOrNull();
        if (customer != null) {
           toGstin = customer.gstin ?? 'URP';
           toStateCode = customer.stateCode ?? '';
           toPin = customer.pinCode ?? '';
        }
      }

      for (var item in items) {
        buffer.write('O,'); // Outward
        buffer.write('1,'); // Supply
        buffer.write('INV,'); // Tax Invoice
        buffer.write('${_escapeCsv(bill.id.split('-').first.toUpperCase())},');
        buffer.write('${_escapeCsv(DateFormat('dd/MM/yyyy').format(bill.date))},');
        
        // Assuming FROM is local (we can leave blank or use a default, typically fetched from settings)
        buffer.write(',,'); // From State Code, From Pin -> leaving blank to fill later
        
        buffer.write('${_escapeCsv(toStateCode)},');
        buffer.write('${_escapeCsv(toPin)},');
        buffer.write('${_escapeCsv(toGstin)},');
        buffer.write('${_escapeCsv(item.productName)},');
        buffer.write('${_escapeCsv(item.hsnCode ?? "")},');
        buffer.write('${_escapeCsv(item.quantity.toString())},');
        buffer.write('NOS,'); // Defaulting UOM
        
        final taxable = item.totalAmount - item.taxAmount;
        buffer.write('${_escapeCsv(taxable.toStringAsFixed(2))},');
        buffer.write('${_escapeCsv(item.taxRate.toStringAsFixed(2))},');
        buffer.write('${_escapeCsv(item.cessRate.toStringAsFixed(2))}');
        buffer.writeln();
      }
    }

    final dirPath = await _getExportDirectory();
    final fileName = 'EWAYBILL_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final filePath = '$dirPath${Platform.pathSeparator}$fileName';
    final file = File(filePath);
    await file.writeAsString(buffer.toString());
    return filePath;
  }
}
