import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';

class AdminDashboardScreen extends StatelessWidget {
  final Function(String)? onNavigate;

  const AdminDashboardScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    // Database Reference
    final db = getIt<AppDatabase>();

    // Mock Data for Charts (Sales data not yet available in DB)
    final double todaysSales = 15430.00;
    final double onlineSales = 3086.0; // 20%
    final double offlineSales = 12344.0; // 80%

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 1100;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Dashboard',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Backoffice overview and analytics',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        // Notification Banner (Compact)
                        StreamBuilder<int>(
                          stream: db.watchPendingPurchaseOrdersCount(),
                          builder: (context, snapshot) {
                            final pendingOrders = snapshot.data ?? 0;
                            return _buildCompactNotification(pendingOrders);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Metrics Row (Compact)
                    StreamBuilder<double>(
                      stream: db.watchTotalInventoryValue(),
                      builder: (context, snapshotInv) {
                        return StreamBuilder<int>(
                          stream: db.watchLowStockItemsCount(),
                          builder: (context, snapshotLow) {
                            return StreamBuilder<int>(
                              stream: db.watchPendingDebitNotesCount(),
                              builder: (context, snapshotDebit) {
                                final totalInventoryValue =
                                    snapshotInv.data ?? 0.0;
                                final lowStockItems = snapshotLow.data ?? 0;
                                final pendingDebitNotes =
                                    snapshotDebit.data ?? 0;

                                final metrics = [
                                  _buildMetricCard(
                                    title: 'Total Inventory',
                                    value:
                                        '₹${totalInventoryValue.toStringAsFixed(0)}',
                                    icon: Icons.inventory_2_outlined,
                                  ),
                                  _buildMetricCard(
                                    title: 'Low Stock',
                                    value: '$lowStockItems Items',
                                    icon: Icons.warning_amber_rounded,
                                    isAlert: true,
                                  ),
                                  StreamBuilder<double>(
                                    stream: db.watchTodaysSales(),
                                    builder: (context, snapshotSales) {
                                      final sales = snapshotSales.data ?? 0.0;
                                      return _buildMetricCard(
                                        title: 'Today\'s Sales',
                                        value: '₹${sales.toStringAsFixed(0)}',
                                        icon: Icons.attach_money,
                                      );
                                    },
                                  ),
                                  _buildMetricCard(
                                    title: 'Pending Debit Notes',
                                    value: '$pendingDebitNotes',
                                    icon: Icons.assignment_return_outlined,
                                    isAlert: false,
                                    onTap: () =>
                                        onNavigate?.call('Debit Notes'),
                                  ),
                                ];

                                if (isSmallScreen) {
                                  return Column(
                                    children: metrics
                                        .map(
                                          (m) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: m,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                } else {
                                  return Row(
                                    children: metrics
                                        .map(
                                          (m) => Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                  ),
                                              child: m,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Charts Row
                    Flex(
                      direction: isSmallScreen
                          ? Axis.vertical
                          : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Revenue Bar Chart
                        isSmallScreen
                            ? Container(
                                height: 320,
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: _buildRevenueChartContent(todaysSales),
                              )
                            : Expanded(
                                flex: 2,
                                child: Container(
                                  height: 320,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: StreamBuilder<double>(
                                    stream: db.watchTodaysSales(),
                                    builder: (context, snapshotSales) {
                                      return _buildRevenueChartContent(
                                        snapshotSales.data ?? 0.0,
                                      );
                                    },
                                  ),
                                ),
                              ),

                        SizedBox(
                          width: isSmallScreen ? 0 : 16,
                          height: isSmallScreen ? 16 : 0,
                        ),

                        // Pie Chart
                        isSmallScreen
                            ? Container(
                                height: 320,
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1C1C1E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _buildPieChartContent(
                                  onlineSales,
                                  offlineSales,
                                ),
                              )
                            : Expanded(
                                flex: 1,
                                child: Container(
                                  height: 320,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1C1E),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: _buildPieChartContent(
                                    onlineSales,
                                    offlineSales,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Management Section
                    Text(
                      'Management Modules',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flex(
                      direction: isSmallScreen
                          ? Axis.vertical
                          : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isSmallScreen
                            ? SizedBox(
                                width: double.infinity,
                                child: _buildManagementCard(
                                  context,
                                  title: 'Inventory & Supply',
                                  items: [
                                    'Purchase Order',
                                    'Vendor Management',
                                    'Transactions',
                                    'Inventory',
                                  ],
                                ),
                              )
                            : Expanded(
                                child: _buildManagementCard(
                                  context,
                                  title: 'Inventory & Supply',
                                  items: [
                                    'Purchase Order',
                                    'Vendor Management',
                                    'Transactions',
                                    'Inventory',
                                  ],
                                ),
                              ),
                        SizedBox(
                          width: isSmallScreen ? 0 : 16,
                          height: isSmallScreen ? 16 : 0,
                        ),
                        isSmallScreen
                            ? SizedBox(
                                width: double.infinity,
                                child: _buildManagementCard(
                                  context,
                                  title: 'Sales & CRM',
                                  items: [
                                    'Customer Management',
                                    'Sales Returns',
                                    'Loyalty Program',
                                    'Quotations',
                                  ],
                                ),
                              )
                            : Expanded(
                                child: _buildManagementCard(
                                  context,
                                  title: 'Sales & CRM',
                                  items: [
                                    'Customer Management',
                                    'Sales Returns',
                                    'Loyalty Program',
                                    'Quotations',
                                  ],
                                ),
                              ),
                        SizedBox(
                          width: isSmallScreen ? 0 : 16,
                          height: isSmallScreen ? 16 : 0,
                        ),
                        isSmallScreen
                            ? SizedBox(
                                width: double.infinity,
                                child: _buildManagementCard(
                                  context,
                                  title: 'Reports & Finance',
                                  items: [
                                    'Day End Report',
                                    'Expense Tracker',
                                    'Tax Summary',
                                    'Profit & Loss',
                                  ],
                                ),
                              )
                            : Expanded(
                                child: _buildManagementCard(
                                  context,
                                  title: 'Reports & Finance',
                                  items: [
                                    'General Ledger',
                                    'Day End Report',
                                    'Expense Tracker',
                                    'Tax Summary',
                                    'Profit & Loss',
                                  ],
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 48), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Widgets ---

  Widget _buildRevenueChartContent(double todaysSales) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getIt<AppDatabase>().getMonthlySales(DateTime.now().year),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final salesData = snapshot.data!;
        // Fill 12 months
        final monthlyTotals = List<double>.filled(12, 0.0);
        for (final row in salesData) {
          final month = row['month'] as int; // 1-12
          if (month >= 1 && month <= 12) {
            monthlyTotals[month - 1] = row['total'] as double;
          }
        }

        final totalYearly = monthlyTotals.fold(0.0, (sum, val) => sum + val);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue (YTD)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${totalYearly.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildChartLegendItem(
                      color: Colors.black,
                      label: DateTime.now().year.toString(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildBarChart(monthlyTotals)),
          ],
        );
      },
    );
  }

  Widget _buildPieChartContent(double onlineSales, double offlineSales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SALES SOURCE',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '₹${(onlineSales + offlineSales).toStringAsFixed(0)}',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 150,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 35,
              sections: [
                PieChartSectionData(
                  color: Colors.white,
                  value: 20,
                  title: '',
                  radius: 18,
                ),
                PieChartSectionData(
                  color: Colors.grey.shade600,
                  value: 80,
                  title: '',
                  radius: 18,
                ),
              ],
              startDegreeOffset: -90,
            ),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDarkLegendItem(color: Colors.white, label: 'WEB'),
            _buildDarkLegendItem(color: Colors.grey.shade600, label: 'COUNTER'),
          ],
        ),
      ],
    );
  }

  Widget _buildBarChart(List<double> data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20000,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  '${(value / 1000).toInt()}k',
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 10),
                );
              },
              interval: 5000,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const titles = [
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
                if (value.toInt() < 0 || value.toInt() >= titles.length)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    titles[value.toInt()],
                    style: GoogleFonts.inter(color: Colors.grey, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5000,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade300, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _generateBarGroups(data),
      ),
    );
  }

  Widget _buildManagementCard(
    BuildContext context, {
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () {
                  if (onNavigate != null) {
                    onNavigate!(item);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactNotification(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.notifications_active, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '$count Orders Pending',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    bool isAlert = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: isAlert
              ? Border.all(color: Colors.black)
              : Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.black, size: 20),
                if (isAlert) Icon(Icons.circle, color: Colors.black, size: 8),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(List<double> data) {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index],
            color: Colors.black,
            width: 8,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
        barsSpace: 4,
      );
    });
  }

  Widget _buildChartLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDarkLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.white54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
