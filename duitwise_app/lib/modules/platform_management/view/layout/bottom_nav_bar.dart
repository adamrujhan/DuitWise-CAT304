import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;

    if (location.startsWith('/home')) {
      currentIndex = 0;
    } else if (location.startsWith('/budget')) {
      currentIndex = 1;
    } else if (location.startsWith('/analytics')) {
      currentIndex = 2;
    } else if (location.startsWith('/learn')) {
      currentIndex = 3;
    }

    return NavigationBar(
      selectedIndex: currentIndex,
      height: 65,
      indicatorColor: Colors.greenAccent.withValues(alpha: 0.2),
      onDestinationSelected: (i) {
        switch (i) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/budget');
            break;
          case 2:
            context.go('/analytics');
            break;
          case 3:
            context.go('/learn');
            break;

        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_outlined, color: Colors.green),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.green,
          ),
          label: 'Tracking',
        ),
        NavigationDestination(
          icon: Icon(Icons.pie_chart_outline_outlined),
          selectedIcon: Icon(
            Icons.pie_chart_outline_outlined,
            color: Colors.green,
          ),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book_outlined, color: Colors.green),
          label: 'Learn',
        ),
      ],
    );
  }
}
