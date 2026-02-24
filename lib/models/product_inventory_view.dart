import '../data/database/app_database.dart';

class ProductInventoryView {
  final Product product;
  final List<ProductBatch> batches;
  final double soldQty;

  ProductInventoryView({
    required this.product,
    required this.batches,
    this.soldQty = 0,
  });

  double get totalStock => batches.fold(0.0, (sum, b) => sum + b.stockQty);

  double? get minMrp {
    if (batches.isEmpty) return null;
    return batches.map((b) => b.mrp).reduce((a, b) => a < b ? a : b);
  }

  double? get maxMrp {
    if (batches.isEmpty) return null;
    return batches.map((b) => b.mrp).reduce((a, b) => a > b ? a : b);
  }

  double? get minSellingPrice {
    if (batches.isEmpty) return null;
    return batches.map((b) => b.sellingPrice).reduce((a, b) => a < b ? a : b);
  }

  double? get maxSellingPrice {
    if (batches.isEmpty) return null;
    return batches.map((b) => b.sellingPrice).reduce((a, b) => a > b ? a : b);
  }
}
