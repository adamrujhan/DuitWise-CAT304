import 'package:duitwise_app/modules/financial_tracking/budget_page.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/bottom_nav_bar.dart';
import 'package:duitwise_app/modules/platform_management/providers/bottom_nav_provider.dart';

// Pages you want to show inside the shell
import 'package:duitwise_app/modules/platform_management/view/home_page.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(bottomNavProvider);

    final pages = [
      const HomePage(),
      const BudgetPage(), //TODO: add more pages
    ];

    return AppScaffold(
      body: pages[tab],
      navBar: const BottomNavBar(),
    );
  }
}
