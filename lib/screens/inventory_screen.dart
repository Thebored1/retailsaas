import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../locator.dart';
import '../data/database/app_database.dart';
import '../models/product_inventory_view.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _db = getIt<AppDatabase>();
  late Stream<List<ProductInventoryView>> _inventoryStream;

  Map<String, String> _categoryNames = {};
  Map<String, String> _brandNames = {};

  final TextEditingController _searchController = TextEditingController();

  String? _selectedCategory;
  String? _selectedBrand;
  bool _showLowStockOnly = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadMetadata();
    _setupStream();
  }

  void _setupStream() {
    final query = _db.select(_db.products).join([
      drift.leftOuterJoin(
        _db.productBatches,
        _db.productBatches.productId.equalsExp(_db.products.id),
      ),
    ]);

    // Active products only
    query.where(_db.products.isActive.equals(true));

    _inventoryStream = query.watch().map((rows) {
      final grouped = <String, ProductInventoryView>{};

      for (final row in rows) {
        final product = row.readTable(_db.products);
        final batch = row.readTableOrNull(_db.productBatches);

        if (!grouped.containsKey(product.id)) {
          grouped[product.id] = ProductInventoryView(
            product: product,
            batches: [],
          );
        }

        if (batch != null) {
          grouped[product.id]!.batches.add(batch);
        }
      }

      return grouped.values.toList();
    });
  }

  Future<void> _loadMetadata() async {
    final cats = await _db.select(_db.categories).get();
    final brands = await _db.select(_db.brands).get();

    if (mounted) {
      setState(() {
        _categoryNames = {for (var c in cats) c.id: c.name};
        _brandNames = {for (var b in brands) b.id: b.name};
      });
    }
  }

  String _getCategoryName(String categoryId) {
    return _categoryNames[categoryId] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: StreamBuilder<List<ProductInventoryView>>(
            stream: _inventoryStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final allItems = snapshot.data ?? [];

              // Filter
              final filteredItems = allItems.where((item) {
                final searchTerm = _searchController.text.toLowerCase();
                final matchesSearch =
                    searchTerm.isEmpty ||
                    item.product.name.toLowerCase().contains(searchTerm);

                final matchesCategory =
                    _selectedCategory == null ||
                    item.product.categoryId == _selectedCategory;

                final matchesLowStock =
                    !_showLowStockOnly ||
                    item.totalStock < item.product.lowStockLimit;

                return matchesSearch && matchesCategory && matchesLowStock;
              }).toList();

              final totalPages = (filteredItems.length / _itemsPerPage).ceil();
              if (_currentPage > totalPages && totalPages > 0)
                _currentPage = totalPages;
              if (_currentPage < 1) _currentPage = 1;

              final startIndex = (_currentPage - 1) * _itemsPerPage;
              final endIndex = (startIndex + _itemsPerPage).clamp(
                0,
                filteredItems.length,
              );

              final paginatedItems = filteredItems.isEmpty
                  ? <ProductInventoryView>[]
                  : filteredItems.sublist(startIndex, endIndex);

              return Column(
                children: [
                  _buildHeader(allItems, filteredItems),
                  _buildFilters(),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              'No products found',
                              style: GoogleFonts.inter(color: Colors.grey),
                            ),
                          )
                        : ListView.separated(
                            itemCount: paginatedItems.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              return _buildProductRow(paginatedItems[index]);
                            },
                          ),
                  ),
                  _buildPagination(totalPages),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductRow(ProductInventoryView item) {
    final hasBatches = item.batches.isNotEmpty;
    final priceRange = hasBatches
        ? '₹${item.minSellingPrice?.toStringAsFixed(2)} - ₹${item.maxSellingPrice?.toStringAsFixed(2)}'
        : '₹ -';

    final isMultiPrice =
        hasBatches && (item.minSellingPrice != item.maxSellingPrice);

    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          image: item.product.imageUrl != null
              ? DecorationImage(
                  image: item.product.imageUrl!.startsWith('http')
                      ? NetworkImage(item.product.imageUrl!)
                      : FileImage(File(item.product.imageUrl!))
                            as ImageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: item.product.imageUrl == null
            ? Icon(Icons.inventory_2_outlined, color: Colors.blue.shade700)
            : null,
      ),
      title: Text(
        item.product.name,
        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        '${_getCategoryName(item.product.categoryId)} • ${item.product.uom}',
        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stock Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.totalStock <= item.product.lowStockLimit
                  ? Colors.red.shade50
                  : Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: item.totalStock <= item.product.lowStockLimit
                    ? Colors.red.shade200
                    : Colors.green.shade200,
              ),
            ),
            child: Text(
              '${item.totalStock.toStringAsFixed(0)} ${item.product.uom}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: item.totalStock <= item.product.lowStockLimit
                    ? Colors.red.shade800
                    : Colors.green.shade800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isMultiPrice
                    ? priceRange
                    : '₹${item.minSellingPrice?.toStringAsFixed(2) ?? "0.00"}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              if (isMultiPrice)
                Text(
                  'Variable',
                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Edit Button (For Product Definition)
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => _showAddItemDialog(product: item.product),
          ),
        ],
      ),
      children: [
        _buildProductDetails(item.product),
        const Divider(height: 1),
        if (hasBatches)
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batches',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                ...item.batches.map((batch) => _buildBatchRow(batch)),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              'No Stock / Batches Available',
              style: GoogleFonts.inter(color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildProductDetails(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _buildDetailItem('ID', product.id),
              _buildDetailItem('Name', product.name),
              _buildDetailItem(
                'Category',
                _getCategoryName(product.categoryId),
              ),
              _buildDetailItem('UOM', product.uom),
              _buildDetailItem('HSN Code', product.hsnCode),
              _buildDetailItem('GST Rate', '${product.gstRate}%'),
              _buildDetailItem('Cess Rate', '${product.cessRate}%'),
              _buildDetailItem('Tax Inclusive', '${product.isTaxInclusive}'),
              _buildDetailItem('Exempt', '${product.isExempt}'),
              _buildDetailItem(
                'Master MRP',
                '₹${product.mrp.toStringAsFixed(2)}',
              ),
              _buildDetailItem(
                'Master SP',
                '₹${product.sellingPrice.toStringAsFixed(2)}',
              ),
              _buildDetailItem(
                'Master Buy Rate',
                '₹${product.purchaseRate.toStringAsFixed(2)}',
              ),
              _buildDetailItem(
                'Low Stock Limit',
                product.lowStockLimit.toString(),
              ),
              _buildDetailItem(
                'Infinite Stock',
                '${product.isInfiniteStock ?? false}',
              ),
              _buildDetailItem('Loose Item', '${product.isLooseItem}'),
              _buildDetailItem('Batch Tracking', '${product.batchTracking}'),
              _buildDetailItem('Active', '${product.isActive}'),
              _buildDetailItem('Created At', product.createdAt.toString()),
              _buildDetailItem('Updated At', product.updatedAt.toString()),
              if (product.imageUrl != null)
                _buildDetailItem('Image URL', product.imageUrl!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchRow(ProductBatch batch) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              batch.batchNumber ?? 'Batch #${batch.id.substring(0, 4)}',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'MRP: ₹${batch.mrp.toStringAsFixed(2)}',
              style: GoogleFonts.inter(fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'SP: ₹${batch.sellingPrice.toStringAsFixed(2)}',
              style: GoogleFonts.inter(fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Buy: ₹${batch.purchaseRate.toStringAsFixed(2)}',
              style: GoogleFonts.inter(fontSize: 13),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Qty: ${batch.stockQty}',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    List<ProductInventoryView> allItems,
    List<ProductInventoryView> filteredItems,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory Management',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Product Definitions and Batches',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() => _currentPage = 1),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Compact Add Button for Mobile
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => _showAddItemDialog(),
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        tooltip: 'Add New Product',
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter Button
                    _buildIconButton(Icons.filter_list, _showFilterDialog),
                  ],
                ),
              ],
            );
          }

          // Desktop Layout
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory Management',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Product Definitions and Batches',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 250,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() => _currentPage = 1),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 18,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Add to Inventory Button
              ElevatedButton.icon(
                onPressed: () => _showAddItemDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  'Add New Product',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Filter Button
              _buildIconButton(Icons.filter_list, _showFilterDialog),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: Colors.black87),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFilters() {
    if (_selectedCategory == null &&
        _selectedBrand == null &&
        !_showLowStockOnly) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            'Filters:',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          if (_selectedCategory != null) ...[
            _buildFilterChip(
              'Category: ${_getCategoryName(_selectedCategory!)}',
              () {
                setState(() {
                  _selectedCategory = null;
                  _currentPage = 1;
                });
              },
            ),
            const SizedBox(width: 8),
          ],
          if (_showLowStockOnly) ...[
            _buildFilterChip('Low Stock Only', () {
              setState(() {
                _showLowStockOnly = false;
              });
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12)),
          const SizedBox(width: 8),
          InkWell(onTap: onRemove, child: const Icon(Icons.close, size: 14)),
        ],
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    if (totalPages <= 1) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: _currentPage > 1
                ? () => setState(() => _currentPage--)
                : null,
          ),
          Text(
            'Page $_currentPage of $totalPages',
            style: GoogleFonts.inter(fontSize: 13),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            onPressed: _currentPage < totalPages
                ? () => setState(() => _currentPage++)
                : null,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? tempCategory = _selectedCategory;
        bool tempLowStock = _showLowStockOnly;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Filter Products',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: tempCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All')),
                        ..._categoryNames.entries.map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ),
                        ),
                      ],
                      onChanged: (v) => setDialogState(() => tempCategory = v),
                    ),
                    CheckboxListTile(
                      title: const Text('Low Stock Only'),
                      value: tempLowStock,
                      onChanged: (v) =>
                          setDialogState(() => tempLowStock = v ?? false),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = tempCategory;
                      _showLowStockOnly = tempLowStock;
                      _currentPage = 1;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g. Dairy, Snacks',
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                final id = const Uuid().v4();
                await _db
                    .into(_db.categories)
                    .insert(CategoriesCompanion.insert(id: id, name: name));
                if (mounted) Navigator.pop(context, id);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog({Product? product}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: product?.name);
    final hsnCodeController = TextEditingController(text: product?.hsnCode);
    final gstRateController = TextEditingController(
      text: product?.gstRate.toStringAsFixed(0) ?? '0',
    );
    final cessRateController = TextEditingController(
      text: product?.cessRate.toStringAsFixed(0) ?? '0',
    );
    final lowStockLimitController = TextEditingController(
      text: product?.lowStockLimit.toString() ?? '0',
    );
    final imageUrlController = TextEditingController(text: product?.imageUrl);

    // Initial stock fields for NEW product only
    final isEditing = product != null;
    final mrpController = TextEditingController(
      text: product?.mrp.toStringAsFixed(0) ?? '',
    );
    final sellingPriceController = TextEditingController(
      text: product?.sellingPrice.toStringAsFixed(0) ?? '',
    );
    final purchaseRateController = TextEditingController(
      text: product?.purchaseRate.toStringAsFixed(0) ?? '',
    );
    final stockQtyController = TextEditingController();

    String? selectedCategory = product?.categoryId;
    String selectedUom = product?.uom ?? 'PCS';

    // Boolean Toggles
    bool isTaxInclusive = product?.isTaxInclusive ?? true;
    bool isExempt = product?.isExempt ?? false;
    bool isInfiniteStock = product?.isInfiniteStock ?? false;
    bool isLooseItem = product?.isLooseItem ?? false;

    bool batchTracking = product?.batchTracking ?? false;

    // Warranty State
    final warrantyMonthsController = TextEditingController(
      text: (product?.warrantyMonths ?? 0).toString(),
    );
    bool isWarrantyAvailable = (product?.warrantyMonths ?? 0) > 0;

    // UOM Hierarchy State
    List<_UomEntry> packagingUnits = [];
    bool uomsLoaded = !isEditing; // If new, we don't need to load

    // Initialize default base for new products
    if (!isEditing) {
      packagingUnits.add(
        _UomEntry(uomName: 'PCS', conversionFactor: 1.0, isBase: true),
      );
    }

    File? pickedImage;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Item',
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.white,
            child: Container(
              width: 500,
              height: double.infinity,
              padding: const EdgeInsets.all(24),
              child: StatefulBuilder(
                builder: (context, setDrawerState) {
                  // Lazy Load UOMs for Edit Mode
                  if (isEditing && !uomsLoaded) {
                    _db.select(_db.productUoms)
                      ..where((t) => t.productId.equals(product!.id))
                      ..get().then((rows) {
                        setDrawerState(() {
                          if (rows.isEmpty) {
                            // Fallback if legacy product
                            packagingUnits.add(
                              _UomEntry(
                                uomName: product!.uom ?? 'PCS',
                                conversionFactor: 1.0,
                                isBase: true,
                              ),
                            );
                          } else {
                            for (var row in rows) {
                              packagingUnits.add(
                                _UomEntry(
                                  uomName: row.uomName,
                                  conversionFactor: row.conversionFactor,
                                  isBase: row.isBase,
                                ),
                              );
                            }
                            // Sort so Base ID is first (optional)
                            packagingUnits.sort((a, b) => b.isBase ? 1 : -1);
                          }
                          uomsLoaded = true;
                        });
                      });
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing ? 'Edit Product' : 'New Product',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField(
                                  controller: nameController,
                                  hint: 'Product Name',
                                  label: 'Product Name',
                                ),
                                const SizedBox(height: 16),
                                // Image Picker
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: pickedImage != null
                                          ? Image.file(
                                              pickedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : (imageUrlController.text.isNotEmpty
                                                ? (imageUrlController.text
                                                          .startsWith('http')
                                                      ? Image.network(
                                                          imageUrlController
                                                              .text,
                                                        )
                                                      : Image.file(
                                                          File(
                                                            imageUrlController
                                                                .text,
                                                          ),
                                                        ))
                                                : const Icon(Icons.image)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () async {
                                        final img = await ImagePicker()
                                            .pickImage(
                                              source: ImageSource.gallery,
                                            );
                                        if (img != null) {
                                          final appDir =
                                              await getApplicationDocumentsDirectory();
                                          final saved = await File(img.path).copy(
                                            '${appDir.path}/${path.basename(img.path)}',
                                          );
                                          setDrawerState(() {
                                            pickedImage = saved;
                                            imageUrlController.text =
                                                saved.path;
                                          });
                                        }
                                      },
                                      child: const Text('Upload Image'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: selectedCategory,
                                        decoration: _buildInputDecoration(
                                          'Category',
                                        ),
                                        items: _categoryNames.entries
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.key,
                                                child: Text(e.value),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) => setDrawerState(
                                          () => selectedCategory = v,
                                        ),
                                        validator: (v) =>
                                            v == null ? 'Required' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        tooltip: 'Add New Category',
                                        onPressed: () async {
                                          final newId =
                                              await _showAddCategoryDialog();
                                          if (newId != null) {
                                            // 1. Refresh global metadata (calls parent setState)
                                            await _loadMetadata();
                                            // 2. Refresh local drawer state
                                            setDrawerState(() {
                                              selectedCategory = newId;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: selectedUom,
                                  decoration: _buildInputDecoration('UOM'),
                                  items: ['PCS', 'KG', 'LTR', 'BOX', 'CTN']
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setDrawerState(
                                    () => selectedUom = v ?? 'PCS',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        controller: hsnCodeController,
                                        hint: 'HSN',
                                        label: 'HSN',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildTextField(
                                        controller: gstRateController,
                                        hint: 'GST %',
                                        label: 'GST %',
                                        isNumber: true,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildTextField(
                                        controller: cessRateController,
                                        hint: 'Cess %',
                                        label: 'Cess %',
                                        isNumber: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: lowStockLimitController,
                                  hint: 'Low Stock Limit',
                                  label: 'Low Stock Limit',
                                  isNumber: true,
                                ),
                                const SizedBox(height: 16),
                                // Warranty Section
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isWarrantyAvailable,
                                      onChanged: (val) {
                                        setDrawerState(() {
                                          isWarrantyAvailable = val ?? false;
                                          if (!isWarrantyAvailable) {
                                            warrantyMonthsController.text = '0';
                                          } else if (warrantyMonthsController
                                                  .text ==
                                              '0') {
                                            warrantyMonthsController.text =
                                                '12'; // Default
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      'Has Warranty?',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isWarrantyAvailable) ...[
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: warrantyMonthsController,
                                    hint: 'Warranty (Months)',
                                    label: 'Warranty Period (Months)',
                                    isNumber: true,
                                  ),
                                ],
                                const SizedBox(height: 16),
                                const SizedBox(height: 16),
                                // Tax Settings
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCheckbox(
                                      label: 'Tax Exempt',
                                      value: isExempt,
                                      onChanged: (v) {
                                        setDrawerState(() {
                                          isExempt = v!;
                                          if (isExempt) {
                                            gstRateController.text = '0';
                                            cessRateController.text = '0';
                                          }
                                        });
                                      },
                                    ),
                                    if (!isExempt) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tax Type',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RadioListTile<bool>(
                                              title: Text(
                                                'Exclusive',
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                ),
                                              ),
                                              value: false,
                                              groupValue: isTaxInclusive,
                                              contentPadding: EdgeInsets.zero,
                                              dense: true,
                                              activeColor: Colors.black,
                                              onChanged: (val) {
                                                setDrawerState(() {
                                                  isTaxInclusive = val!;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: RadioListTile<bool>(
                                              title: Text(
                                                'Inclusive',
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                ),
                                              ),
                                              value: true,
                                              groupValue: isTaxInclusive,
                                              contentPadding: EdgeInsets.zero,
                                              dense: true,
                                              activeColor: Colors.black,
                                              onChanged: (val) {
                                                setDrawerState(() {
                                                  isTaxInclusive = val!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),

                                const SizedBox(height: 24),
                                // Packaging Hierarchy
                                Text(
                                  'Packaging Hierarchy',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      ...packagingUnits.asMap().entries.map((
                                        entry,
                                      ) {
                                        final index = entry.key;
                                        final unit = entry.value;
                                        return Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border:
                                                index <
                                                    packagingUnits.length - 1
                                                ? Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          Colors.grey.shade200,
                                                    ),
                                                  )
                                                : null,
                                            color: unit.isBase
                                                ? Colors.blue.shade50
                                                      .withOpacity(0.3)
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              // Details
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        if (unit.isBase)
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                  right: 8,
                                                                ),
                                                            child: Icon(
                                                              Icons.stars,
                                                              size: 16,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        Text(
                                                          unit.isBase
                                                              ? "Base Unit"
                                                              : "Pack Unit ${index}",
                                                          style:
                                                              GoogleFonts.inter(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        // UOM Name
                                                        Expanded(
                                                          flex: 2,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: TextField(
                                                              controller:
                                                                  unit.nameCtrl,
                                                              readOnly:
                                                                  unit.isBase,
                                                              decoration: InputDecoration(
                                                                labelText:
                                                                    "Unit Name",
                                                                border:
                                                                    OutlineInputBorder(),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8,
                                                                    ),
                                                                filled:
                                                                    unit.isBase,
                                                              ),
                                                              onChanged: (v) {
                                                                setDrawerState(
                                                                  () {
                                                                    unit.uomName =
                                                                        v;
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        // Conversion Factor
                                                        Expanded(
                                                          flex: 1,
                                                          child: SizedBox(
                                                            height: 40,
                                                            child: TextField(
                                                              controller: unit
                                                                  .factorCtrl,
                                                              readOnly:
                                                                  unit.isBase,
                                                              decoration: InputDecoration(
                                                                labelText:
                                                                    "1 = ?",
                                                                border:
                                                                    OutlineInputBorder(),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8,
                                                                    ),
                                                                filled:
                                                                    unit.isBase,
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChanged: (v) {
                                                                setDrawerState(() {
                                                                  unit.conversionFactor =
                                                                      double.tryParse(
                                                                        v,
                                                                      ) ??
                                                                      1.0;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    // Helper Text
                                                    if (!unit.isBase)
                                                      Text(
                                                        "1 ${unit.nameCtrl.text} = ${unit.factorCtrl.text} ${packagingUnits.firstWhere((x) => x.isBase).nameCtrl.text}",
                                                        style:
                                                            GoogleFonts.inter(
                                                              fontSize: 11,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                            ),
                                                      ),

                                                    // Barcode Removed
                                                    SizedBox(height: 8),
                                                  ],
                                                ),
                                              ),
                                              // Delete Action
                                              if (!unit.isBase)
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red.shade300,
                                                  ),
                                                  onPressed: () {
                                                    setDrawerState(() {
                                                      unit.dispose();
                                                      packagingUnits.removeAt(
                                                        index,
                                                      );
                                                    });
                                                  },
                                                ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      const SizedBox(height: 16),
                                      // Boolean Flags
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            SwitchListTile(
                                              value: isLooseItem,
                                              onChanged: (v) => setDrawerState(
                                                () => isLooseItem = v,
                                              ),
                                              title: Text(
                                                'Loose Item',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle: Text(
                                                'Sold in fractional quantities (e.g. kg, ltr)',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            const Divider(height: 1),
                                            SwitchListTile(
                                              value: batchTracking,
                                              onChanged: (v) => setDrawerState(
                                                () => batchTracking = v,
                                              ),
                                              title: Text(
                                                'Batch Tracking',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle: Text(
                                                'Track expiry dates and batches',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Add Button
                                      InkWell(
                                        onTap: () {
                                          setDrawerState(() {
                                            packagingUnits.add(
                                              _UomEntry(
                                                uomName: 'BOX',
                                                conversionFactor: 12.0,
                                              ),
                                            );
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_circle_outline,
                                                size: 16,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "+ Add Packaging Unit",
                                                style: GoogleFonts.inter(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Pricing (Master)',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        controller: mrpController,
                                        hint: 'MRP',
                                        label: 'MRP',
                                        isNumber: true,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildTextField(
                                        controller: sellingPriceController,
                                        hint: 'SP',
                                        label: 'Selling Price',
                                        isNumber: true,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildTextField(
                                        controller: purchaseRateController,
                                        hint: 'Buy Rate',
                                        label: 'Purchase Rate',
                                        isNumber: true,
                                      ),
                                    ),
                                  ],
                                ),

                                if (!isEditing) ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          controller: stockQtyController,
                                          hint: 'Qty',
                                          label: 'Initial Stock Quantity',
                                          isNumber: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate() &&
                                selectedCategory != null) {
                              final now = DateTime.now();
                              try {
                                await _db.transaction(() async {
                                  // Auto-logic for Infinite Stock on creation
                                  if (!isEditing) {
                                    if (stockQtyController.text == '0') {
                                      isInfiniteStock = true;
                                    } else {
                                      isInfiniteStock = false;
                                    }
                                  }

                                  final targetId = isEditing
                                      ? product!.id
                                      : const Uuid().v4();

                                  if (isEditing) {
                                    await (_db.update(
                                      _db.products,
                                    )..where((t) => t.id.equals(targetId))).write(
                                      ProductsCompanion(
                                        name: drift.Value(nameController.text),
                                        categoryId: drift.Value(
                                          selectedCategory!,
                                        ),
                                        hsnCode: drift.Value(
                                          hsnCodeController.text,
                                        ),
                                        gstRate: drift.Value(
                                          double.parse(gstRateController.text),
                                        ),
                                        cessRate: drift.Value(
                                          double.tryParse(
                                                cessRateController.text,
                                              ) ??
                                              0.0,
                                        ),
                                        isTaxInclusive: drift.Value(
                                          isTaxInclusive,
                                        ),
                                        isExempt: drift.Value(isExempt),
                                        lowStockLimit: drift.Value(
                                          double.parse(
                                            lowStockLimitController.text,
                                          ),
                                        ),
                                        isInfiniteStock: drift.Value(
                                          isInfiniteStock,
                                        ),
                                        isLooseItem: drift.Value(isLooseItem),
                                        batchTracking: drift.Value(
                                          batchTracking,
                                        ),
                                        mrp: drift.Value(
                                          double.tryParse(mrpController.text) ??
                                              0.0,
                                        ),
                                        sellingPrice: drift.Value(
                                          double.tryParse(
                                                sellingPriceController.text,
                                              ) ??
                                              0.0,
                                        ),
                                        purchaseRate: drift.Value(
                                          double.tryParse(
                                                purchaseRateController.text,
                                              ) ??
                                              0.0,
                                        ),
                                        uom: drift.Value(selectedUom),
                                        imageUrl: drift.Value(
                                          imageUrlController.text.isNotEmpty
                                              ? imageUrlController.text
                                              : null,
                                        ),
                                        warrantyMonths: drift.Value(
                                          isWarrantyAvailable
                                              ? int.tryParse(
                                                      warrantyMonthsController
                                                          .text,
                                                    ) ??
                                                    0
                                              : 0,
                                        ),
                                        updatedAt: drift.Value(now),
                                      ),
                                    );
                                  } else {
                                    await _db
                                        .into(_db.products)
                                        .insert(
                                          ProductsCompanion.insert(
                                            id: targetId,
                                            name: nameController.text,
                                            categoryId: selectedCategory!,
                                            hsnCode: hsnCodeController.text,
                                            gstRate:
                                                double.tryParse(
                                                  gstRateController.text,
                                                ) ??
                                                0,
                                            cessRate: drift.Value(
                                              double.tryParse(
                                                    cessRateController.text,
                                                  ) ??
                                                  0.0,
                                            ),
                                            isTaxInclusive: drift.Value(
                                              isTaxInclusive,
                                            ),
                                            isExempt: drift.Value(isExempt),
                                            lowStockLimit:
                                                double.tryParse(
                                                  lowStockLimitController.text,
                                                ) ??
                                                0,
                                            isInfiniteStock: drift.Value(
                                              isInfiniteStock,
                                            ),
                                            isLooseItem: drift.Value(
                                              isLooseItem,
                                            ),
                                            batchTracking: drift.Value(
                                              batchTracking,
                                            ),
                                            mrp: drift.Value(
                                              double.tryParse(
                                                    mrpController.text,
                                                  ) ??
                                                  0.0,
                                            ),
                                            sellingPrice: drift.Value(
                                              double.tryParse(
                                                    sellingPriceController.text,
                                                  ) ??
                                                  0.0,
                                            ),
                                            purchaseRate: drift.Value(
                                              double.tryParse(
                                                    purchaseRateController.text,
                                                  ) ??
                                                  0.0,
                                            ),
                                            uom: selectedUom,
                                            imageUrl: drift.Value(
                                              imageUrlController.text.isNotEmpty
                                                  ? imageUrlController.text
                                                  : null,
                                            ),
                                            warrantyMonths: drift.Value(
                                              isWarrantyAvailable
                                                  ? int.tryParse(
                                                          warrantyMonthsController
                                                              .text,
                                                        ) ??
                                                        0
                                                  : 0,
                                            ),
                                            createdAt: now,
                                            updatedAt: now,
                                          ),
                                        );

                                    // Optional Initial Batch
                                    if (stockQtyController.text.isNotEmpty &&
                                        double.tryParse(
                                              stockQtyController.text,
                                            )! >
                                            0) {
                                      await _db.findOrCreateBatch(
                                        productId: targetId,
                                        mrp:
                                            double.tryParse(
                                              mrpController.text,
                                            ) ??
                                            0,
                                        buyPrice:
                                            double.tryParse(
                                              purchaseRateController.text,
                                            ) ??
                                            0,
                                        quantity:
                                            double.tryParse(
                                              stockQtyController.text,
                                            ) ??
                                            0,
                                      );
                                    }
                                  }

                                  // ----------------------------------------
                                  // Save UOMs
                                  // ----------------------------------------
                                  // 1. Delete Old UOMs for this product
                                  await (_db.delete(_db.productUoms)..where(
                                        (t) => t.productId.equals(targetId),
                                      ))
                                      .go();

                                  // 2. Insert New
                                  for (var unit in packagingUnits) {
                                    await _db
                                        .into(_db.productUoms)
                                        .insert(
                                          ProductUomsCompanion(
                                            productId: drift.Value(targetId),
                                            uomName: drift.Value(
                                              unit.nameCtrl.text,
                                            ),
                                            conversionFactor: drift.Value(
                                              double.tryParse(
                                                    unit.factorCtrl.text,
                                                  ) ??
                                                  1.0,
                                            ),
                                            isBase: drift.Value(unit.isBase),
                                          ),
                                        );
                                  }
                                });
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error saving product: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            isEditing ? 'Save Changes' : 'Create Product',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: GoogleFonts.inter(fontSize: 13)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    String? label,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: isNumber
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                if (isNumber) return 'Required'; // simplified
                return 'Required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
    );
  }
}

class _UomEntry {
  String uomName;
  double conversionFactor;
  bool isBase;
  TextEditingController nameCtrl;
  TextEditingController factorCtrl;

  _UomEntry({
    required this.uomName,
    required this.conversionFactor,
    this.isBase = false,
  }) : nameCtrl = TextEditingController(text: uomName),
       factorCtrl = TextEditingController(text: conversionFactor.toString());

  void dispose() {
    nameCtrl.dispose();
    factorCtrl.dispose();
  }
}
