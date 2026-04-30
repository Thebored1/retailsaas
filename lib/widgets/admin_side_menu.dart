import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:drift/drift.dart' hide Column;
import '../locator.dart';
import '../data/database/app_database.dart';
import '../screens/product_selection_screen.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';

class AdminSideMenu extends StatefulWidget {
  final String selectedItem;
  final Function(String) onItemSelected;

  const AdminSideMenu({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  State<AdminSideMenu> createState() => _AdminSideMenuState();
}

class _AdminSideMenuState extends State<AdminSideMenu> {
  // Enhanced categories with Icons
  final List<_AdminCategory> _menuItems = [
    _AdminCategory(
      title: 'Webfront',
      icon: Icons.storefront_outlined,
      items: [
        'Manage Orders',
        'Delivery Slots',
        'Delivery Agents',
        'Online Customers',
      ],
    ),
    _AdminCategory(
      title: 'Inventory & Supply',
      icon: Icons.inventory_2_outlined,
      items: [
        'Purchase Order',
        'Vendor Management',
        'Vendor Payments',
        'Transactions',
        'Inventory',
        'Stock Ledger',
      ],
    ),

    _AdminCategory(
      title: 'Reports & Finance',
      icon: Icons.analytics_outlined,
      items: [
        'General Ledger',
        'Chart of Accounts', // Liquid Assets
        'Expense Tracker',
        'Tax Summary',
        'Profit & Loss',
        'Debit Notes',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExcludeFocusTraversal(
      child: Material(
        color: Colors.white,
        child: SizedBox(
          width: 290,
          child: Column(
            children: [
            const SizedBox(height: 24),
            // Header / Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.dashboard_customize,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Retail Admin',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSingleMenuItem(
                    icon: Icons.grid_view,
                    label: 'Sales',
                    isSelected: widget.selectedItem == 'Sales',
                    onTap: () => widget.onItemSelected('Sales'),
                  ),
                  const SizedBox(height: 4),
                  _buildSingleMenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isSelected: widget.selectedItem == 'Settings',
                    onTap: () => widget.onItemSelected('Settings'),
                  ),
                  const SizedBox(height: 8),
                  ..._menuItems.map((category) {
                    return _buildCategoryTile(category);
                  }),
                ],
              ),
            ),

            // User / Bottom Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        // Fallback: If cannot pop (e.g. opened directly), replace with Home
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const ProductSelectionScreen(),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Back to POS',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      getIt<AuthService>().logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            size: 16,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // DB Viewer (Debug)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () {
                  final db = getIt<AppDatabase>();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DriftDbViewer(db as GeneratedDatabase),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.storage, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Open DB Viewer',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSingleMenuItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black.withOpacity(0.04)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.black : Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(_AdminCategory category) {
    // Check if any child satisfies selection to auto-expand or highlight
    final bool isAnyChildSelected = category.items.contains(
      widget.selectedItem,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        initiallyExpanded: isAnyChildSelected,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        childrenPadding: EdgeInsets.zero,
        leading: Icon(
          category.icon,
          size: 20,
          color: isAnyChildSelected ? Colors.black : Colors.grey.shade500,
        ),
        title: Text(
          category.title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isAnyChildSelected ? FontWeight.w600 : FontWeight.w500,
            color: isAnyChildSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: Colors.grey.shade400,
        ),
        shape: const Border(), // Remove borders
        children: category.items.map((item) {
          final isSelected = widget.selectedItem == item;
          return _buildSubMenuItem(
            label: item,
            isSelected: isSelected,
            onTap: () => widget.onItemSelected(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubMenuItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 44, bottom: 4, right: 0), // Indent
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Active indicator dot
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCategory {
  final String title;
  final IconData icon;
  final List<String> items;

  _AdminCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}
