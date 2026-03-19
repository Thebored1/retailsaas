import 'package:flutter/material.dart';
import 'package:retailsaas/screens/admin_dashboard_screen.dart';
import 'package:retailsaas/screens/debit_note_screen.dart';
import 'package:retailsaas/screens/inventory_screen.dart';

import 'package:retailsaas/screens/ledger_screen.dart';
import 'package:retailsaas/screens/stock_ledger_screen.dart';
import 'package:retailsaas/screens/purchase_order_list_screen.dart';
import 'package:retailsaas/screens/stock_adjustment_screen.dart';
import 'package:retailsaas/screens/vendor_management_screen.dart';
import 'package:retailsaas/screens/vendor_payment_screen.dart';
import 'package:retailsaas/screens/customer_management_screen.dart';
import 'package:retailsaas/screens/delivery_slots_screen.dart';
import 'package:retailsaas/screens/delivery_agent_accounts_screen.dart';
import 'package:retailsaas/screens/online_orders_management_screen.dart';
import 'package:retailsaas/screens/settings_screen.dart';
import 'package:retailsaas/widgets/admin_side_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/screens/audit_logs_screen.dart';
import 'package:retailsaas/screens/finance/liquid_assets_screen.dart';

class AdminMainScreen extends StatefulWidget {
  final String initialItem;
  const AdminMainScreen({super.key, this.initialItem = 'Dashboard'});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  late String _selectedItem;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialItem;
  }

  void _handleItemSelected(String item) {
    setState(() {
      _selectedItem = item;
    });

    // If drawer is open (mobile), close it
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 900;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF5F5F7),

          // AppBar only on small screens to show Menu button
          appBar: isSmallScreen
              ? AppBar(
                  backgroundColor: const Color(0xFFF5F5F7),
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  title: Text(
                    'Retail Admin', // Or selected item name
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              : null,

          // Drawer for Mobile
          drawer: isSmallScreen
              ? Drawer(
                  backgroundColor: Colors.white,
                  child: AdminSideMenu(
                    selectedItem: _selectedItem,
                    onItemSelected: _handleItemSelected,
                  ),
                )
              : null,

          body: Row(
            children: [
              // Sidebar for Desktop
              if (!isSmallScreen)
                AdminSideMenu(
                  selectedItem: _selectedItem,
                  onItemSelected: _handleItemSelected,
                ),

              // Content Area
              Expanded(child: _buildContent()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (_selectedItem) {
      case 'Dashboard':
        return AdminDashboardScreen(
          // Pass callback to allow dashboard to switch views (e.g. clicking a card)
          onNavigate: _handleItemSelected,
        );
      case 'Settings':
        return const SettingsScreen();
      case 'Vendor Management':
        return const VendorManagementScreen();
      case 'Online Customers':
        return const CustomerManagementScreen();
      case 'Delivery Slots':
        return const DeliverySlotsScreen();
      case 'Delivery Agents':
        return const DeliveryAgentAccountsScreen();
      case 'Manage Orders':
        return const OnlineOrdersManagementScreen();
      case 'Vendor Payments':
        return const VendorPaymentScreen();
      // Add other cases here as we build them, or default placeholders
      case 'Purchase Order':
        return const PurchaseOrderListScreen();
      case 'Debit Notes':
        return const DebitNoteScreen();
      case 'Transactions':
        return const StockAdjustmentScreen();

      case 'Inventory':
        return const InventoryScreen();
      case 'General Ledger':
        return const LedgerScreen();
      case 'Stock Ledger':
        return const StockLedgerScreen();
      case 'Audit Logs':
        return const AuditLogsScreen();
      case 'Chart of Accounts':
        return const LiquidAssetsScreen();

      case 'Day End Report':
      case 'Expense Tracker':
      case 'Tax Summary':
      case 'Profit & Loss':
        return _buildPlaceholder(_selectedItem);
      default:
        return _buildPlaceholder('Not Implemented');
    }
  }

  Widget _buildPlaceholder(String title) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              '$title Coming Soon',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
