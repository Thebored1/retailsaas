import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/data/database/app_database.dart';
import 'package:retailsaas/locator.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';

class LiquidAssetsScreen extends StatelessWidget {
  const LiquidAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = getIt<AppDatabase>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(
          'Chart of Accounts',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // TODO: Add New Account Modal
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Account>>(
        stream: db.select(db.accounts).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final allAccounts = snapshot.data!;
          // Filter for Liquid Assets Hierarchy (Children of '1000' -> Current Assets -> Cash/Bank)
          // For now, we visualize everything under "Current Assets" (1000)

          // Calculate Totals
          double totalLiquid = 0;
          double totalCash = 0;
          double totalBank = 0;
          double totalDigital = 0;

          for (var acc in allAccounts) {
            if (acc.parentId == '1001') {
              // Children of 'Cash & Equivalents'
              totalLiquid += acc.currentBalance;
              if (acc.subType == 'Cash') totalCash += acc.currentBalance;
              if (acc.subType == 'Bank') totalBank += acc.currentBalance;
              if (acc.subType == 'Digital') totalDigital += acc.currentBalance;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Summary Section
                _buildSummaryDashboard(
                  totalLiquid,
                  totalCash,
                  totalBank,
                  totalDigital,
                ),
                const SizedBox(height: 24),

                // Hierarchy Tree
                Text(
                  'ACCOUNTS HIERARCHY',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                _buildHierarchyList(allAccounts),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryDashboard(
    double total,
    double cash,
    double bank,
    double digital,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Liquid Assets',
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '₹${total.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
                width: 60,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 15,
                    sections: [
                      PieChartSectionData(
                        color: Colors.green,
                        value: cash,
                        radius: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.blue,
                        value: bank,
                        radius: 10,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.purple,
                        value: digital,
                        radius: 10,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMiniCard('Cash', cash, Colors.green, Icons.money),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCard(
                  'Bank',
                  bank,
                  Colors.blue,
                  Icons.account_balance,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCard(
                  'Digital',
                  digital,
                  Colors.purple,
                  Icons.qr_code,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '₹${(amount / 1000).toStringAsFixed(1)}k',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHierarchyList(List<Account> accounts) {
    // Find Root Children (Level 1 - e.g. "Current Assets")
    // Or simpler, start from Level 2 (Cash & Equivalents) if that's the focus
    final cashEquivalents = accounts.firstWhere(
      (a) => a.id == '1001',
      orElse: () => accounts.firstWhere((a) => a.parentId == null),
    );

    return _buildAccountNode(cashEquivalents, accounts, level: 0);
  }

  Widget _buildAccountNode(Account node, List<Account> all, {int level = 0}) {
    final children = all.where((a) => a.parentId == node.id).toList();
    final isLeaf = children.isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        initiallyExpanded: level < 2, // Auto expand top levels
        shape: const Border(),
        tilePadding: EdgeInsets.only(
          left: 16 + (level * 16.0),
          right: 16,
          top: 0,
          bottom: 0,
        ),
        leading: _getIconForType(node.subType ?? node.type),
        title: Text(
          node.name,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: node.assignedUserId != null
            ? Text(
                'User: ${node.assignedUserId}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₹${node.currentBalance.toStringAsFixed(0)}',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            if (!isLeaf) const Icon(Icons.arrow_drop_down),
            if (isLeaf)
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Text('View Ledger'),
                  ),
                  const PopupMenuItem(
                    value: 'transfer',
                    child: Text('Transfer Funds'),
                  ),
                ],
              ),
          ],
        ),
        children: children
            .map((c) => _buildAccountNode(c, all, level: level + 1))
            .toList(),
      ),
    );
  }

  Widget _getIconForType(String type) {
    IconData icon = Icons.folder;
    Color color = Colors.grey;

    switch (type) {
      case 'Cash':
        icon = Icons.money;
        color = Colors.green;
        break;
      case 'Bank':
        icon = Icons.account_balance;
        color = Colors.blue;
        break;
      case 'Digital':
        icon = Icons.qr_code;
        color = Colors.purple;
        break;
      case 'Asset':
        icon = Icons.account_balance_wallet;
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}
