import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import '../locator.dart';
import '../utils/image_helper.dart';
import 'dart:convert';
import '../data/database/app_database.dart';
import '../models/product_inventory_view.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Processes image bytes off the UI thread: decodes, resizes to max 800x800, and encodes to JPEG.
Uint8List _processImageBytes(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;

  // Resize if too large
  img.Image resized = decoded;
  if (decoded.width > 800 || decoded.height > 800) {
    resized = img.copyResize(
      decoded,
      width: decoded.width > decoded.height ? 800 : null,
      height: decoded.height >= decoded.width ? 800 : null,
    );
  }

  return Uint8List.fromList(img.encodeJpg(resized, quality: 75));
}

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

  static const List<String> _bulkUploadHeaders = [
    'RowType',
    'ProductId',
    'ProductName',
    'CategoryName',
    'ImageUrl',
    'UOM',
    'HSNCode',
    'GSTRate',
    'CessRate',
    'IsTaxInclusive',
    'IsExempt',
    'LowStockLimit',
    'IsInfiniteStock',
    'IsLooseItem',
    'BatchTracking',
    'WarrantyMonths',
    'IsActive',
    'MasterMRP',
    'MasterSellingPrice',
    'MasterPurchaseRate',
    'InitialStockQty',
    'BatchNumber',
    'BatchExpiryDate',
    'BatchMRP',
    'BatchSellingPrice',
    'BatchPurchaseRate',
    'BatchStockQty',
    'UOM2',
    'UOM2Factor',
    'UOM2Barcode',
    'UOM3',
    'UOM3Factor',
    'UOM3Barcode',
  ];

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

    final imageUrl = (item.product.imageUrl ?? '').trim();
    final imageB64 = (item.product.imageB64 ?? '').trim();

    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          image: imageB64.isNotEmpty || imageUrl.isNotEmpty
              ? DecorationImage(
                  image: imageB64.isNotEmpty
                      ? MemoryImage(base64Decode(imageB64))
                      : (imageUrl.startsWith('http')
                          ? NetworkImage(imageUrl)
                          : FileImage(File(imageUrl)) as ImageProvider),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageB64.isEmpty && imageUrl.isEmpty
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
                    // Bulk Upload Button
                    _buildIconButton(Icons.upload_file, _handleBulkUpload),
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
              OutlinedButton.icon(
                onPressed: _handleBulkUpload,
                icon: const Icon(Icons.upload_file, size: 18),
                label: Text(
                  'Bulk Upload',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey.shade300),
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
    String? pickedImageB64; // raw base64 (no data: prefix)

    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('New Category'),
            content: SizedBox(
              width: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      hintText: 'e.g. Dairy, Snacks',
                    ),
                    textCapitalization: TextCapitalization.words,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  // Image picker row
                  Row(
                    children: [
                      // Preview thumbnail
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: pickedImageB64 != null
                            ? Image.memory(
                                base64Decode(pickedImageB64!),
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image_outlined, color: Colors.grey, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                              allowMultiple: false,
                            );
                            if (result == null || result.files.isEmpty) return;

                            final file = File(result.files.first.path!);
                            final rawBytes = await file.readAsBytes();

                            // Process off UI thread to prevent jank/crashes
                            final processedBytes = await compute(_processImageBytes, rawBytes);
                            final b64 = base64Encode(processedBytes);
                            
                            setDialogState(() => pickedImageB64 = b64);
                          },
                          icon: const Icon(Icons.upload_rounded, size: 18),
                          label: Text(
                            pickedImageB64 != null ? 'Change Image' : 'Upload Image',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
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
                onPressed: () async {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    final id = const Uuid().v4();
                    await _db.into(_db.categories).insert(
                          CategoriesCompanion.insert(
                            id: id,
                            name: name,
                            imageB64: drift.Value(pickedImageB64),
                          ),
                        );
                    if (mounted) Navigator.pop(context, id);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
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
    
    // Support base64 image preview for new/edited products
    String? pickedImageB64 = product?.imageB64;

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
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: pickedImageB64 != null
                                          ? Image.memory(
                                              base64Decode(pickedImageB64!),
                                              fit: BoxFit.cover,
                                            )
                                          : ImageHelper.getImageWidget(
                                              imageUrlController.text,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () async {
                                        final result = await FilePicker.platform.pickFiles(
                                          type: FileType.image,
                                          allowMultiple: false,
                                        );
                                        if (result == null || result.files.isEmpty) return;

                                        final file = File(result.files.first.path!);
                                        final rawBytes = await file.readAsBytes();

                                        // Process off UI thread
                                        final processedBytes = await compute(_processImageBytes, rawBytes);
                                        final b64 = base64Encode(processedBytes);

                                        setDrawerState(() {
                                          pickedImageB64 = b64;
                                        });
                                      },
                                      icon: const Icon(Icons.upload, size: 16),
                                      label: const Text('Upload Image'),
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
                                        icon: const Icon(Icons.edit),
                                        tooltip: 'Edit Category',
                                        onPressed: selectedCategory == null
                                            ? null
                                            : () async {
                                                final updated =
                                                    await _showEditCategoryDialog(
                                                      selectedCategory!,
                                                    );
                                                if (updated) {
                                                  await _loadMetadata();
                                                  setDrawerState(() {});
                                                }
                                              },
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
                                        imageB64: drift.Value(pickedImageB64),
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
                                            imageB64: drift.Value(pickedImageB64),
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

  Future<void> _handleBulkUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['xlsx'],
      );
      if (result == null || result.files.single.path == null) return;

      final filePath = result.files.single.path;
      if (filePath == null) {
        _showUploadError('Bulk upload failed: file path is empty.');
        return;
      }
      final bytes = await File(filePath).readAsBytes();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);

      const sheetName = 'Inventory Upload';
      final sheet = decoder.tables[sheetName];
      if (sheet == null) {
        _showUploadError(
          'Invalid file: missing sheet "$sheetName".',
        );
        return;
      }
    if (sheet.rows.isEmpty) {
      _showUploadError('Invalid file: header row not found.');
      return;
    }

    final headerRow = sheet.rows.first;
    final headers = List<String>.generate(
      _bulkUploadHeaders.length,
      (i) => _cellString(headerRow, i),
    );

    final headerLengthMatches =
        headerRow.length == _bulkUploadHeaders.length;
    final headerOrderMatches = List.generate(_bulkUploadHeaders.length, (i) {
      return headers[i] == _bulkUploadHeaders[i];
    }).every((v) => v);

    if (!headerLengthMatches || !headerOrderMatches) {
      _showUploadError(
        'Header mismatch. Please use the provided template without changing column order.',
      );
      return;
    }

      final categories = await _db.select(_db.categories).get();
      final categoryByName = {
        for (final c in categories) c.name.toLowerCase().trim(): c.id
      };
    final existingProducts = await _db.select(_db.products).get();
    final existingIds = existingProducts.map((p) => p.id).toSet();

    final errors = <String>[];
    final rowsToImport = <Map<String, dynamic>>[];
    final seenIds = <String>{};
    int emptyRows = 0;
    int sampleRows = 0;
    int dataRows = 0;

    for (int r = 1; r < sheet.rows.length; r++) {
      final row = sheet.rows[r];
      if (_isRowEmpty(row)) {
        emptyRows++;
        continue;
      }

      final rowType = _cellString(row, 0).trim();
      if (rowType.toLowerCase() == 'sample') {
        sampleRows++;
        continue;
      }

      final rowIndex = r + 1;
      dataRows++;

      final productId = _cellString(row, 1).trim();
      final productName = _cellString(row, 2).trim();
      final categoryName = _cellString(row, 3).trim();
      final imageUrl = _cellString(row, 4).trim();
      final uom = _cellString(row, 5).trim();
      final hsnCode = _cellString(row, 6).trim();

      final gstRate = _parseDouble(_cellString(row, 7));
      final cessRate = _parseDouble(_cellString(row, 8)) ?? 0.0;
      final isTaxInclusive =
          _parseBool(_cellString(row, 9), defaultValue: true);
      final isExempt = _parseBool(_cellString(row, 10), defaultValue: false);
      final lowStockLimit = _parseDouble(_cellString(row, 11));
      final isInfiniteStock =
          _parseBool(_cellString(row, 12), defaultValue: false);
      final isLooseItem =
          _parseBool(_cellString(row, 13), defaultValue: false);
      final batchTracking =
          _parseBool(_cellString(row, 14), defaultValue: false);
      final warrantyMonths =
          _parseInt(_cellString(row, 15), defaultValue: 0);
      final isActive = _parseBool(_cellString(row, 16), defaultValue: true);

      final masterMrp = _parseDouble(_cellString(row, 17));
      final masterSp = _parseDouble(_cellString(row, 18));
      final masterPurchase = _parseDouble(_cellString(row, 19));
      final initialStock = _parseDouble(_cellString(row, 20)) ?? 0.0;

      final batchNumber = _cellString(row, 21).trim();
      final batchExpiry = _parseDate(row, 22);
      final batchMrp = _parseDouble(_cellString(row, 23));
      final batchSp = _parseDouble(_cellString(row, 24));
      final batchPurchase = _parseDouble(_cellString(row, 25));
      final batchQty = _parseDouble(_cellString(row, 26));

      final uom2 = _cellString(row, 27).trim();
      final uom2Factor = _parseDouble(_cellString(row, 28));
      final uom2Barcode = _cellString(row, 29).trim();
      final uom3 = _cellString(row, 30).trim();
      final uom3Factor = _parseDouble(_cellString(row, 31));
      final uom3Barcode = _cellString(row, 32).trim();

      if (productName.isEmpty) {
        errors.add('Row $rowIndex: ProductName is required.');
      }
      if (categoryName.isEmpty) {
        errors.add('Row $rowIndex: CategoryName is required.');
      }
      if (uom.isEmpty) {
        errors.add('Row $rowIndex: UOM is required.');
      }
      if (hsnCode.isEmpty) {
        errors.add('Row $rowIndex: HSNCode is required.');
      }
      if (gstRate == null) {
        errors.add('Row $rowIndex: GSTRate is required.');
      }
      if (lowStockLimit == null) {
        errors.add('Row $rowIndex: LowStockLimit is required.');
      }
      if (masterMrp == null || masterSp == null || masterPurchase == null) {
        errors.add(
          'Row $rowIndex: MasterMRP, MasterSellingPrice, and MasterPurchaseRate are required.',
        );
      }

      if (productId.isNotEmpty) {
        if (existingIds.contains(productId)) {
          errors.add('Row $rowIndex: ProductId "$productId" already exists.');
        }
        if (seenIds.contains(productId)) {
          errors.add('Row $rowIndex: Duplicate ProductId "$productId" in file.');
        }
        seenIds.add(productId);
      }

      if (uom2.isNotEmpty && (uom2Factor == null || uom2Factor <= 0)) {
        errors.add('Row $rowIndex: UOM2Factor must be > 0.');
      }
      if (uom3.isNotEmpty && (uom3Factor == null || uom3Factor <= 0)) {
        errors.add('Row $rowIndex: UOM3Factor must be > 0.');
      }

      rowsToImport.add({
        'rowIndex': rowIndex,
        'productId': productId,
        'productName': productName,
        'categoryName': categoryName,
        'imageUrl': imageUrl,
        'uom': uom,
        'hsnCode': hsnCode,
        'gstRate': gstRate ?? 0.0,
        'cessRate': cessRate,
        'isTaxInclusive': isTaxInclusive,
        'isExempt': isExempt,
        'lowStockLimit': lowStockLimit ?? 0.0,
        'isInfiniteStock': isInfiniteStock,
        'isLooseItem': isLooseItem,
        'batchTracking': batchTracking,
        'warrantyMonths': warrantyMonths,
        'isActive': isActive,
        'masterMrp': masterMrp ?? 0.0,
        'masterSp': masterSp ?? 0.0,
        'masterPurchase': masterPurchase ?? 0.0,
        'initialStock': initialStock,
        'batchNumber': batchNumber,
        'batchExpiry': batchExpiry,
        'batchMrp': batchMrp,
        'batchSp': batchSp,
        'batchPurchase': batchPurchase,
        'batchQty': batchQty,
        'uom2': uom2,
        'uom2Factor': uom2Factor,
        'uom2Barcode': uom2Barcode,
        'uom3': uom3,
        'uom3Factor': uom3Factor,
        'uom3Barcode': uom3Barcode,
      });
    }

    if (errors.isNotEmpty) {
      _showUploadValidationErrors(errors);
      return;
    }

    if (rowsToImport.isEmpty) {
      _showUploadError(
        'No data rows found to import. '
        'Total rows: ${sheet.rows.length - 1}, '
        'Empty: $emptyRows, Sample: $sampleRows, Data: $dataRows.',
      );
      return;
    }

    await _db.transaction(() async {
      for (final row in rowsToImport) {
        try {
          final now = DateTime.now();
          final productId = (row['productId'] as String).isNotEmpty
              ? row['productId'] as String
              : const Uuid().v4();

          final categoryName = (row['categoryName'] as String).trim();
          String categoryId;
          final key = categoryName.toLowerCase();
          if (categoryByName.containsKey(key)) {
            categoryId = categoryByName[key]!;
          } else {
            categoryId = const Uuid().v4();
            await _db.into(_db.categories).insert(
                  CategoriesCompanion.insert(
                    id: categoryId,
                    name: categoryName,
                  ),
                );
            categoryByName[key] = categoryId;
          }

          final imageUrl = row['imageUrl'] as String;
          final storedImagePath =
              await _ingestImageForProduct(imageUrl, productId);

          await _db.into(_db.products).insert(
                ProductsCompanion.insert(
                  id: productId,
                  name: row['productName'] as String,
                  categoryId: categoryId,
                  hsnCode: row['hsnCode'] as String,
                  gstRate: row['gstRate'] as double,
                  cessRate: drift.Value(row['cessRate'] as double),
                  isTaxInclusive: drift.Value(row['isTaxInclusive'] as bool),
                  isExempt: drift.Value(row['isExempt'] as bool),
                  lowStockLimit: row['lowStockLimit'] as double,
                  isInfiniteStock: drift.Value(row['isInfiniteStock'] as bool),
                  isLooseItem: drift.Value(row['isLooseItem'] as bool),
                  batchTracking: drift.Value(row['batchTracking'] as bool),
                  mrp: drift.Value(row['masterMrp'] as double),
                  sellingPrice: drift.Value(row['masterSp'] as double),
                  purchaseRate: drift.Value(row['masterPurchase'] as double),
                  uom: row['uom'] as String,
                  imageUrl: drift.Value(
                  (storedImagePath ?? '').isNotEmpty ? storedImagePath : null,
                  ),
                  warrantyMonths: drift.Value(row['warrantyMonths'] as int),
                  isActive: drift.Value(row['isActive'] as bool),
                  createdAt: now,
                  updatedAt: now,
                ),
              );

          await _db.into(_db.productUoms).insert(
                ProductUomsCompanion(
                  productId: drift.Value(productId),
                  uomName: drift.Value(row['uom'] as String),
                  conversionFactor: drift.Value(1.0),
                  isBase: drift.Value(true),
                  barcode: const drift.Value(null),
                ),
              );

          final uom2Name = row['uom2'] as String;
          final uom2Factor = row['uom2Factor'] as double?;
          final uom2Barcode = row['uom2Barcode'] as String;
          if (uom2Name.isNotEmpty && (uom2Factor ?? 0) > 0) {
            await _db.into(_db.productUoms).insert(
                  ProductUomsCompanion(
                    productId: drift.Value(productId),
                    uomName: drift.Value(uom2Name),
                    conversionFactor: drift.Value(uom2Factor ?? 1.0),
                    isBase: drift.Value(false),
                    barcode: drift.Value(uom2Barcode.isNotEmpty ? uom2Barcode : null),
                  ),
                );
          }

          final uom3Name = row['uom3'] as String;
          final uom3Factor = row['uom3Factor'] as double?;
          final uom3Barcode = row['uom3Barcode'] as String;
          if (uom3Name.isNotEmpty && (uom3Factor ?? 0) > 0) {
            await _db.into(_db.productUoms).insert(
                  ProductUomsCompanion(
                    productId: drift.Value(productId),
                    uomName: drift.Value(uom3Name),
                    conversionFactor: drift.Value(uom3Factor ?? 1.0),
                    isBase: drift.Value(false),
                    barcode: drift.Value(uom3Barcode.isNotEmpty ? uom3Barcode : null),
                  ),
                );
          }

          final batchQty = (row['batchQty'] as double?) ?? 0.0;
          final initialStock = row['initialStock'] as double;
          final effectiveQty = batchQty > 0 ? batchQty : initialStock;

          if (effectiveQty > 0) {
            final batchMrp =
                (row['batchMrp'] as double?) ?? row['masterMrp'] as double;
            final batchPurchase =
                (row['batchPurchase'] as double?) ?? row['masterPurchase'] as double;
            final batchSp =
                (row['batchSp'] as double?) ?? row['masterSp'] as double;
            final batchNumber = (row['batchNumber'] as String).isNotEmpty
                ? row['batchNumber'] as String
                : null;
            final batchExpiry = row['batchExpiry'] as DateTime?;

            await _db.findOrCreateBatch(
              productId: productId,
              mrp: batchMrp,
              buyPrice: batchPurchase,
              quantity: effectiveQty,
              expiry: batchExpiry,
              batchNumber: batchNumber,
            );

            if (batchSp != batchMrp) {
              final existing = await (_db.select(_db.productBatches)
                    ..where((t) =>
                        t.productId.equals(productId) & t.mrp.equals(batchMrp))
                    ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])
                    ..limit(1))
                  .getSingleOrNull();

              if (existing != null && existing.sellingPrice != batchSp) {
                await (_db.update(_db.productBatches)
                      ..where((t) => t.id.equals(existing.id)))
                    .write(ProductBatchesCompanion(
                      sellingPrice: drift.Value(batchSp),
                      updatedAt: drift.Value(DateTime.now()),
                    ));
              }
            }
          }
        } catch (e) {
          final rowIndex = row['rowIndex'] as int? ?? -1;
          throw Exception('Row $rowIndex failed: $e');
        }
      }
    });

    _showUploadSuccess('Imported ${rowsToImport.length} items successfully.');
    } catch (e, st) {
      _showUploadError('Bulk upload failed: $e');
      debugPrint('Bulk upload error: $e');
      debugPrint(st.toString());
    }
  }

  String _cellString(List<dynamic> row, int index) {
    if (index >= row.length) return '';
    final value = row[index];
    if (value == null) return '';
    return value.toString().trim();
  }

  bool _isRowEmpty(List<dynamic> row) {
    for (final value in row) {
      if (value == null) continue;
      if (value.toString().trim().isNotEmpty) return false;
    }
    return true;
  }

  bool _parseBool(String value, {required bool defaultValue}) {
    final v = value.trim().toLowerCase();
    if (v.isEmpty) return defaultValue;
    if (v == 'true' || v == '1' || v == 'yes') return true;
    if (v == 'false' || v == '0' || v == 'no') return false;
    return defaultValue;
  }

  double? _parseDouble(String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    return double.tryParse(v);
  }

  int _parseInt(String value, {required int defaultValue}) {
    final v = value.trim();
    if (v.isEmpty) return defaultValue;
    return int.tryParse(v) ?? defaultValue;
  }

  DateTime? _parseDate(List<dynamic> row, int index) {
    if (index >= row.length) return null;
    final value = row[index];
    if (value == null) return null;
    if (value is DateTime) return value;
    final str = value.toString().trim();
    if (str.isEmpty) return null;
    return DateTime.tryParse(str);
  }

  Future<String?> _ingestImageForProduct(
    String source,
    String productId,
  ) async {
    final src = source.trim();
    if (src.isEmpty) return null;

    List<int> bytes;
    if (src.startsWith('http://') || src.startsWith('https://')) {
      final resp = await http.get(Uri.parse(src));
      if (resp.statusCode != 200) {
        throw Exception('Image download failed (${resp.statusCode})');
      }
      bytes = resp.bodyBytes;
    } else {
      final file = File(src);
      if (!file.existsSync()) {
        throw Exception('Image file not found: $src');
      }
      bytes = await file.readAsBytes();
    }

    final decoded = img.decodeImage(Uint8List.fromList(bytes));
    if (decoded == null) {
      throw Exception('Unsupported image format');
    }

    // Resize large images to keep storage reasonable
    final resized = (decoded.width > 1200 || decoded.height > 1200)
        ? img.copyResize(decoded, width: 1200)
        : decoded;

    final outBytes = img.encodeJpg(resized, quality: 80);

    final dir = await getApplicationDocumentsDirectory();
    final imgDir = Directory(path.join(dir.path, 'product_images'));
    if (!imgDir.existsSync()) {
      imgDir.createSync(recursive: true);
    }
    final outPath = path.join(imgDir.path, '$productId.jpg');
    await File(outPath).writeAsBytes(outBytes, flush: true);
    return outPath;
  }

  void _showUploadError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bulk Upload Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showEditCategoryDialog(String categoryId) async {
    final cat = await (_db.select(_db.categories)..where((t) => t.id.equals(categoryId))).getSingleOrNull();
    if (cat == null) return false;

    final controller = TextEditingController(text: cat.name);
    String? pickedImageB64 = cat.imageB64;

    return (await showDialog<bool>(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Edit Category'),
                content: SizedBox(
                  width: 340,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Category Name',
                        ),
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: pickedImageB64 != null
                                ? Image.memory(
                                    base64Decode(pickedImageB64!),
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_outlined, color: Colors.grey, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                  allowMultiple: false,
                                );
                                if (result == null || result.files.isEmpty) return;

                                final file = File(result.files.first.path!);
                                final rawBytes = await file.readAsBytes();

                                // Background processing
                                final processedBytes = await compute(_processImageBytes, rawBytes);
                                final b64 = base64Encode(processedBytes);
                                setDialogState(() => pickedImageB64 = b64);
                              },
                              icon: const Icon(Icons.upload_rounded, size: 18),
                              label: Text(
                                pickedImageB64 != null ? 'Change Image' : 'Upload Image',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newName = controller.text.trim();
                      if (newName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Name cannot be empty')),
                        );
                        return;
                      }

                      final lower = newName.toLowerCase();
                      final duplicate = _categoryNames.entries.any(
                        (e) => e.key != categoryId && e.value.toLowerCase() == lower,
                      );
                      if (duplicate) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Category already exists')),
                        );
                        return;
                      }

                      await (_db.update(_db.categories)
                            ..where((t) => t.id.equals(categoryId)))
                          .write(CategoriesCompanion(
                        name: drift.Value(newName),
                        imageB64: drift.Value(pickedImageB64),
                      ));
                      Navigator.pop(context, true);
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
        )) ??
        false;
  }

  void _showUploadValidationErrors(List<String> errors) {
    if (!mounted) return;
    final preview = errors.length > 8 ? errors.sublist(0, 8) : errors;
    final moreCount = errors.length - preview.length;
    final message = StringBuffer()
      ..writeln(preview.join('\n'))
      ..writeln(moreCount > 0 ? '\n...and $moreCount more.' : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Fix These Rows'),
        content: Text(message.toString().trim()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showUploadSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
