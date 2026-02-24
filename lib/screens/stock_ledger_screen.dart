import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data/database/app_database.dart';
import '../locator.dart';

class StockLedgerScreen extends StatefulWidget {
  const StockLedgerScreen({super.key});

  @override
  State<StockLedgerScreen> createState() => _StockLedgerScreenState();
}

class _StockLedgerScreenState extends State<StockLedgerScreen> {
  final _db = getIt<AppDatabase>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Light gray background
      body: StreamBuilder<List<StockLedgerEntry>>(
        stream: _db.watchStockLedger(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data ?? [];

          // Optional: Filter entries based on search text
          final filteredEntries = entries.where((entry) {
            final query = _searchController.text.toLowerCase();
            if (query.isEmpty) return true;
            return entry.product.name.toLowerCase().contains(query) ||
                (entry.transaction.location?.toLowerCase().contains(query) ??
                    false);
          }).toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Metrics Row
                    StreamBuilder<LedgerMetrics>(
                      stream: _db.watchLedgerMetrics(),
                      builder: (context, metricSnapshot) {
                        final metrics =
                            metricSnapshot.data ??
                            LedgerMetrics(
                              totalSwaps: 0,
                              rmaInventory: 0,
                              goodStockOut: 0,
                            );

                        // Simplified Row for Metrics
                        return Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                title: 'Total Swaps',
                                value: metrics.totalSwaps.toString(),
                                icon: Icons.sync,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                title: 'RMA Inventory',
                                value: metrics.rmaInventory.toString(),
                                icon: Icons.broken_image,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                title: 'Good Stock Out',
                                value: metrics.goodStockOut.toString(),
                                icon: Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Main Content Card
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            _buildHeader(),

                            Expanded(
                              child: filteredEntries.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No transactions found',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      child: _buildDataTable(filteredEntries),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stock Ledger',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Track all inventory movements and locations',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
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
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search product or location...',
                hintStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
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
          _buildIconButton(Icons.filter_list, () {}),
          const SizedBox(width: 8),
          _buildIconButton(Icons.file_download_outlined, () {}),
        ],
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

  Widget _buildDataTable(List<StockLedgerEntry> entries) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(const Color(0xFFF9FAFB)),
        headingRowHeight: 48,
        dataRowMinHeight: 52,
        dataRowMaxHeight: 52,
        columnSpacing: 24,
        horizontalMargin: 24,
        columns: [
          DataColumn(label: Text('Date', style: _headerStyle())),
          DataColumn(label: Text('Type', style: _headerStyle())),
          DataColumn(label: Text('Product', style: _headerStyle())),
          DataColumn(label: Text('Batch', style: _headerStyle())),
          DataColumn(label: Text('Location', style: _headerStyle())),
          DataColumn(label: Text('Qty', style: _headerStyle())),
        ],
        rows: entries.map((entry) {
          final isReturn = entry.transaction.type == 'Return';
          final isReplacement = entry.transaction.type == 'Replacement';

          Color typeColor = Colors.grey;
          if (isReturn) typeColor = Colors.orange;
          if (isReplacement) typeColor = Colors.blue;
          if (entry.transaction.type == 'Sale') typeColor = Colors.green;

          // Location Badge Color
          Color locColor = Colors.grey.shade100;
          Color locTextColor = Colors.black87;
          if (entry.transaction.location == 'RMA_BIN') {
            locColor = Colors.red.shade50;
            locTextColor = Colors.red.shade900;
          } else if (entry.transaction.location == 'SHOP_FLOOR') {
            locColor = Colors.green.shade50;
            locTextColor = Colors.green.shade900;
          }

          return DataRow(
            cells: [
              DataCell(
                Text(
                  DateFormat(
                    'dd MMM, yyyy',
                  ).format(entry.transaction.date), // Polished Date
                  style: _cellStyle(),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12), // Rounded Pill
                  ),
                  child: Text(
                    // Title Case Badge
                    toBeginningOfSentenceCase(
                          entry.transaction.type.toLowerCase(),
                        ) ??
                        entry.transaction.type,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: typeColor,
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 200,
                  child: Text(
                    entry.product.name,
                    style: _cellStyle(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Text(
                  entry.batch?.batchNumber ?? '-',
                  style: _cellStyle(color: Colors.grey.shade700),
                ),
              ),
              DataCell(
                entry.transaction.location != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: locColor,
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded Pill
                        ),
                        child: Text(
                          // Title Case Location
                          entry.transaction.location!
                              .split('_')
                              .map(
                                (word) => toBeginningOfSentenceCase(
                                  word.toLowerCase(),
                                ),
                              )
                              .join(' '),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: locTextColor,
                          ),
                        ),
                      )
                    : const Text('-'),
              ),
              DataCell(
                Text(
                  entry.transaction.quantity
                      .abs()
                      .toInt()
                      .toString(), // Integer Qty
                  style: _cellStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  TextStyle _headerStyle() {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade700,
    );
  }

  TextStyle _cellStyle({FontWeight? fontWeight, Color? color}) {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black87,
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
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
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
