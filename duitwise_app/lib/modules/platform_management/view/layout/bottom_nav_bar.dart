import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/modules/platform_management/providers/bottom_nav_provider.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(bottomNavProvider);

    return NavigationBar(
      selectedIndex: tab,
      height: 65,
      indicatorColor: Colors.greenAccent.withValues(alpha: 0.2),
      onDestinationSelected: (index) {
        ref.read(bottomNavProvider.notifier).state = index;
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Colors.grey),
          selectedIcon: Icon(
            Icons.home_outlined,
            color: Colors.green,
            shadows: [Shadow(color: Colors.blue, blurRadius: 8)],
          ),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined, color: Colors.grey),
          selectedIcon: Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.green,
            shadows: [Shadow(color: Colors.blue, blurRadius: 8)],
          ),
          label: "Tracking",
        ),
        NavigationDestination(
          icon: Icon(Icons.pie_chart_outline_outlined, color: Colors.grey),
          selectedIcon: Icon(
            Icons.pie_chart_outline_outlined,
            color: Colors.green,
            shadows: [Shadow(color: Colors.blue, blurRadius: 8)],
          ),
          label: "Analytics",
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined, color: Colors.grey),
          selectedIcon: Icon(
            Icons.menu_book_outlined,
            color: Colors.green,
            shadows: [Shadow(color: Colors.blue, blurRadius: 8)],
          ),
          label: "Learn",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: Colors.grey),
          selectedIcon: Icon(
            Icons.person_outline,
            color: Colors.green,
            shadows: [Shadow(color: Colors.blue, blurRadius: 8)],
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
