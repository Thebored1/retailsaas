import 'package:flutter/material.dart';
import '../widgets/pos_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PosContent(
      title: 'Select Products',
      successAnimationPath: 'assets/animations/wallet_animation.json',
      successAnimationLoop: true,
      successButtonText: 'Back to POS',
    );
  }
}
