import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/modules/platform_management/providers/bottom_nav_provider.dart';
import 'package:go_router/go_router.dart';

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
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/budget');
            break;
          case 2: 
            context.go('/learn');
            break;
          case 3: 
            context.go('/profile');
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet_rounded),
          label: "Tracking",
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book_rounded),
          label: "Learn",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person_rounded),
          label: "Profile",
        ),
      ],
    );
  }
}
