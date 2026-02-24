import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';
import 'dashboard_screen.dart';
import 'returns_screen.dart';

class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Side Menu (Shell Navigation)
          SideMenu(
            selectedIndex: _selectedIndex,
            onIndexChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Container(width: 1, color: Colors.grey.shade200),

          // Main Content Area
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [DashboardScreen(), ReturnsScreen()],
            ),
          ),
        ],
      ),
    );
  }
}
