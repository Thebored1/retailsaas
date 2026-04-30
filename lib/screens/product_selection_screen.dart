import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';
import 'dashboard_screen.dart';
import 'returns_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 900;
        return Scaffold(
          backgroundColor: Colors.white,
          drawer: isSmallScreen
              ? Drawer(
                  width: 80,
                  child: SideMenu(
                    selectedIndex: _selectedIndex,
                    onIndexChanged: (index) {
                      setState(() => _selectedIndex = index);
                      Navigator.pop(context);
                    },
                  ),
                )
              : null,
          appBar: isSmallScreen
              ? AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  title: Text(
                    _selectedIndex == 0 ? 'Sales' : 'Returns',
                    style: GoogleFonts.inter(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isSmallScreen) ...[
                SideMenu(
                  selectedIndex: _selectedIndex,
                  onIndexChanged: (index) =>
                      setState(() => _selectedIndex = index),
                ),
                Container(width: 1, color: Colors.grey.shade200),
              ],
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: const [DashboardScreen(), ReturnsScreen()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
