import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/screens/admin_main_screen.dart';
import 'package:retailsaas/services/auth_service.dart';
import 'package:retailsaas/locator.dart';
import 'package:retailsaas/screens/login_screen.dart';

class SideMenu extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.grid_view, 'label': 'Dashboard'},
    {'icon': Icons.assignment_return_outlined, 'label': 'Returns'},
    // Add more items here if needed later (e.g. Settings, Logout)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Logo or App Icon placeholder could go here
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'P', // Placeholder for Logo
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Menu Items
          Expanded(
            child: ListView.separated(
              itemCount: _menuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = widget.selectedIndex == index;

                return InkWell(
                  onTap: () => widget.onIndexChanged(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected ? Colors.white : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Admin Button at bottom
          if (getIt<AuthService>().isAdmin())
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminMainScreen(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.selectedIndex == 2
                            ? Colors.black
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings_outlined,
                        color: widget.selectedIndex == 2
                            ? Colors.white
                            : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Admin',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: widget.selectedIndex == 2
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: widget.selectedIndex == 2
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: InkWell(
              onTap: () {
                getIt<AuthService>().logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.logout,
                      color: Colors.red.shade400,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
