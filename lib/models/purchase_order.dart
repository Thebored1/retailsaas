class PurchaseOrder {
  final String id;
  final String poNumber;
  final String vendorName;
  final String date;
  final String status;
  final double amount;
  final int itemsCount;
  final String? grnId;
  final String? grnNumber;
  final String? vendorBillNumber;
  final String? vendorBillDate;

  const PurchaseOrder({
    required this.id,
    required this.poNumber,
    required this.vendorName,
    required this.date,
    required this.status,
    required this.amount,
    required this.itemsCount,
    this.grnId,
    this.grnNumber,
    this.vendorBillNumber,
    this.vendorBillDate,
  });
}
