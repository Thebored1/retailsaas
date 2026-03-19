import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key});

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  final _db = getIt<AppDatabase>();
  List<Product> _products = []; // Keep for metrics
  List<TransactionWithProduct> _transactions = [];
  List<TransactionWithProduct> _filteredTransactions = [];
  List<Category> _categories = [];
  List<Brand> _brands = [];
  final TextEditingController _searchController = TextEditingController();

  String? _selectedCategory;
  String? _selectedBrand;
  bool _showLowStockOnly =
      false; // This filter might need adjustment for transactions
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transactions = await _db.getRecentTransactions();
    final products = await _db.select(_db.products).get(); // Needed for metrics
    final categories = await _db.select(_db.categories).get();
    final brands = await _db.select(_db.brands).get();

    if (mounted) {
      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions;
        _products = products; // Keep for metrics
        _categories = categories;
        _brands = brands;
      });
    }
  }

  void _filterProducts() {
    setState(() {
      _filteredTransactions = _transactions.where((item) {
        final product = item.product;
        final transaction = item.transaction;

        final searchTerm = _searchController.text.toLowerCase();
        final matchesSearch =
            searchTerm.isEmpty ||
            product.name.toLowerCase().contains(searchTerm) ||
            (transaction.orderId != null &&
                transaction.orderId!.toLowerCase().contains(searchTerm));

        final matchesCategory =
            _selectedCategory == null ||
            product.categoryId == _selectedCategory;

        // final matchesLowStock = ... // Low stock filter might not apply to transactions list directly, or could filter by product stock

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  String _getCategoryName(String categoryId) {
    return _categories
        .firstWhere(
          (c) => c.id == categoryId,
          orElse: () => Category(id: '', name: 'Unknown'),
        )
        .name;
  }

  String _getBrandName(String brandId) {
    return _brands
        .firstWhere(
          (b) => b.id == brandId,
          orElse: () => Brand(id: '', name: 'Unknown'),
        )
        .name;
  }

  // Calculate metrics
  // Calculate metrics
  // Calculate metrics
  double get totalSales => _transactions
      .where(
        (t) => t.transaction.type == 'Sale' || t.transaction.type == 'Pos Sale',
      )
      .fold(0, (sum, t) => sum + t.transaction.totalAmount);

  double get totalReturns => _transactions
      .where((t) => t.transaction.type == 'Return')
      .fold(0, (sum, t) => sum + t.transaction.totalAmount);

  double get netRevenue => totalSales - totalReturns;

  // int get lowStockItems =>
  //    _products.where((p) => p.stockQty < p.lowStockLimit).length;
  // TODO: Refactor for Batch Stock
  int get lowStockItems => 0;

  @override
  Widget build(BuildContext context) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(
      0,
      _filteredTransactions.length,
    );
    final paginatedTransactions = _filteredTransactions.sublist(
      startIndex,
      endIndex,
    );
    final totalPages = (_filteredTransactions.length / _itemsPerPage).ceil();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 900) {
            return _buildMobileLayout(paginatedTransactions, totalPages);
          } else {
            return _buildDesktopLayout(paginatedTransactions, totalPages);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(
    List<TransactionWithProduct> transactions,
    int totalPages,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Metrics Row
          _buildMetricsRow(),
          const SizedBox(height: 16),
          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  _buildFilters(),
                  Expanded(child: _buildFlexTable(transactions)),
                  _buildPagination(totalPages),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    List<TransactionWithProduct> transactions,
    int totalPages,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Metrics Row
          _buildMetricsRow(),
          const SizedBox(height: 16),
          // Main Content (No Expanded)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                _buildFilters(),
                // No Expanded here, let it take natural height
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildScrollableTable(transactions),
                ),
                _buildPagination(totalPages),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 4;
        if (width < 600) {
          crossAxisCount = 1;
        } else if (width < 1100) {
          crossAxisCount = 2;
        }

        final card1 = _buildMetricCard(
          'Total Sales',
          '₹${totalSales.toStringAsFixed(0)}',
          'Gross revenue from all sales',
        );
        final card2 = _buildMetricCard(
          'Total Returns',
          '₹${totalReturns.toStringAsFixed(0)}',
          'Total value of returned items',
        );
        final card3 = _buildMetricCard(
          'Low Stock Items',
          lowStockItems.toString(),
          'Items below stock alert limit',
        );
        final card4 = _buildMetricCard(
          'Net Revenue',
          '₹${netRevenue.toStringAsFixed(0)}',
          'Gross sales minus total returns',
        );

        final cards = [card1, card2, card3, card4];

        if (crossAxisCount == 1) {
          return Column(
            children: cards
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: c,
                  ),
                )
                .toList(),
          );
        } else if (crossAxisCount == 2) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: card1),
                  const SizedBox(width: 16),
                  Expanded(child: card2),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: card3),
                  const SizedBox(width: 16),
                  Expanded(child: card4),
                ],
              ),
            ],
          );
        } else {
          // Desktop 4 columns
          return Row(
            children: [
              Expanded(child: card1),
              const SizedBox(width: 16),
              Expanded(child: card2),
              const SizedBox(width: 16),
              Expanded(child: card3),
              const SizedBox(width: 16),
              Expanded(child: card4),
            ],
          );
        }
      },
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              Icon(Icons.more_horiz, size: 18, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 1100;

          if (isSmallScreen) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Transaction',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Latest transactions from all products',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Actions
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    // Search Bar
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
                        onChanged: (_) => _filterProducts(),
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
                    // Filter Button
                    _buildIconButton(Icons.filter_list, _showFilterDialog),
                    // Customize Button
                    _buildIconButton(Icons.tune, () {}),
                    // Export Button
                    _buildIconButton(Icons.file_download_outlined, () {}),
                  ],
                ),
              ],
            );
          }

          // Desktop Row Layout
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Transaction',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Latest transactions from all products',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Search Bar
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
                  onChanged: (_) => _filterProducts(),
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
              // Filter Button
              _buildIconButton(Icons.filter_list, _showFilterDialog),
              const SizedBox(width: 8),
              // Customize Button
              _buildIconButton(Icons.tune, () {}),
              const SizedBox(width: 8),
              // Export Button
              _buildIconButton(Icons.file_download_outlined, () {}),
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
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
                  _filterProducts();
                });
              },
            ),
            const SizedBox(width: 8),
          ],
          if (_selectedBrand != null) ...[
            _buildFilterChip('Brand: ${_getBrandName(_selectedBrand!)}', () {
              setState(() {
                _selectedBrand = null;
                _filterProducts();
              });
            }),
            const SizedBox(width: 8),
          ],
          if (_showLowStockOnly) ...[
            _buildFilterChip('Low Stock Only', () {
              setState(() {
                _showLowStockOnly = false;
                _filterProducts();
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

  Widget _buildFlexTable(List<TransactionWithProduct> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Header Row
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Transaction ID', style: _headerStyle()),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Product', style: _headerStyle()),
                ),
                Expanded(flex: 3, child: Text('Date', style: _headerStyle())),
                Expanded(flex: 2, child: Text('Type', style: _headerStyle())),
                Expanded(flex: 2, child: Text('Price', style: _headerStyle())),
                Expanded(flex: 1, child: Text('Qty', style: _headerStyle())),
                Expanded(flex: 2, child: Text('Total', style: _headerStyle())),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Data Rows
          Expanded(
            child: ListView.separated(
              itemCount: transactions.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, thickness: 0.5),
              itemBuilder: (context, index) {
                final item = transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: _buildFlexRow(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlexRow(TransactionWithProduct item) {
    final product = item.product;
    final transaction = item.transaction;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            (transaction.type == 'Sale' || transaction.type == 'Pos Sale') &&
                    transaction.orderId != null
                ? '#${transaction.orderId!.length > 8 ? transaction.orderId!.substring(0, 8) : transaction.orderId!}'
                : '#${transaction.id.length > 4 ? transaction.id.substring(transaction.id.length - 4) : transaction.id}',
            style: _cellStyle(),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            product.name,
            style: _cellStyle(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            '${transaction.date.day} ${_getMonthName(transaction.date.month)}, ${transaction.date.year}',
            style: _cellStyle(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _buildTypeBadge(transaction.type),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '₹${transaction.price.toStringAsFixed(0)}',
            style: _cellStyle(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${transaction.quantity.abs().toStringAsFixed(0)}',
            style: _cellStyle(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '₹${transaction.totalAmount.toStringAsFixed(0)}',
            style: _cellStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableTable(List<TransactionWithProduct> transactions) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
        headingRowHeight: 48,
        dataRowMinHeight: 52,
        dataRowMaxHeight: 52,
        columnSpacing: 24,
        horizontalMargin: 24,
        columns: [
          DataColumn(label: Text('Transaction ID', style: _headerStyle())),
          DataColumn(label: Text('Product', style: _headerStyle())),
          DataColumn(label: Text('Date', style: _headerStyle())),
          DataColumn(label: Text('Type', style: _headerStyle())),
          DataColumn(label: Text('Price', style: _headerStyle())),
          DataColumn(label: Text('Qty', style: _headerStyle())),
          DataColumn(label: Text('Total', style: _headerStyle())),
        ],
        rows: transactions.asMap().entries.map((entry) {
          final item = entry.value;
          final product = item.product;
          final transaction = item.transaction;

          return DataRow(
            cells: [
              DataCell(
                Text(
                  (transaction.type == 'Sale' ||
                              transaction.type == 'Pos Sale') &&
                          transaction.orderId != null
                      ? '#${transaction.orderId!.length > 8 ? transaction.orderId!.substring(0, 8) : transaction.orderId!}'
                      : '#${transaction.id.length > 4 ? transaction.id.substring(transaction.id.length - 4) : transaction.id}',
                  style: _cellStyle(),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 150,
                  child: Text(
                    product.name,
                    style: _cellStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '${transaction.date.day} ${_getMonthName(transaction.date.month)}, ${transaction.date.year}',
                  style: _cellStyle(),
                ),
              ),
              DataCell(_buildTypeBadge(transaction.type)),
              DataCell(
                Text(
                  '₹${transaction.price.toStringAsFixed(0)}',
                  style: _cellStyle(),
                ),
              ),
              DataCell(
                Text(
                  '${transaction.quantity.abs().toStringAsFixed(0)}',
                  style: _cellStyle(),
                ),
              ),
              DataCell(
                Text(
                  '₹${transaction.totalAmount.toStringAsFixed(0)}',
                  style: _cellStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    Color color = Colors.grey;
    if (type == 'Sale' || type == 'Pos Sale') color = Colors.green;
    if (type == 'Return') color = Colors.orange;
    if (type == 'Adjustment') color = Colors.blue;
    if (type == 'Replacement')
      color = Colors.purple; // Distinct color for Warranty Out

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildPagination(int totalPages) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Show: ',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Text(
                      '$_itemsPerPage',
                      style: GoogleFonts.inter(fontSize: 13),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, size: 18),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
              ),
              ...List.generate(totalPages.clamp(0, 5), (index) {
                final page = index + 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _currentPage == page
                            ? Colors.black
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$page',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: _currentPage == page
                              ? Colors.white
                              : Colors.black,
                          fontWeight: _currentPage == page
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: _currentPage < totalPages
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
              ),
            ],
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
        String? tempBrand = _selectedBrand;
        bool tempLowStock = _showLowStockOnly;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Filter Products',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: tempCategory,
                      decoration: InputDecoration(
                        hintText: 'Select Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Categories'),
                        ),
                        ..._categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat.id!,
                            child: Text(cat.name!),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          tempCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Brand',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: tempBrand,
                      decoration: InputDecoration(
                        hintText: 'Select Brand',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Brands'),
                        ),
                        ..._brands.map((brand) {
                          return DropdownMenuItem(
                            value: brand.id!,
                            child: Text(brand.name!),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          tempBrand = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: Text(
                        'Show Low Stock Only',
                        style: GoogleFonts.inter(),
                      ),
                      value: tempLowStock,
                      onChanged: (value) {
                        setDialogState(() {
                          tempLowStock = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: GoogleFonts.inter()),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = tempCategory;
                      _selectedBrand = tempBrand;
                      _showLowStockOnly = tempLowStock;
                      _filterProducts();
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Apply Filters', style: GoogleFonts.inter()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  TextStyle _headerStyle() {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }

  TextStyle _cellStyle({FontWeight? fontWeight, Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
