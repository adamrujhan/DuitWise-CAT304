import 'package:duitwise_app/modules/financial_literacy/views/fin_lit_page.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/duitwise_appbar.dart';
import 'package:duitwise_app/modules/user_profile/view/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Layout
import 'package:duitwise_app/modules/platform_management/view/layout/app_scaffold.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/bottom_nav_bar.dart';

// Navigation state
import 'package:duitwise_app/modules/platform_management/providers/bottom_nav_provider.dart';

// Feature pages
import 'package:duitwise_app/modules/platform_management/view/home_page.dart';
//import 'package:duitwise_app/modules/financial_tracking/budget_setup_page.dart';
//import 'package:duitwise_app/modules/financial_tracking/budget_page.dart';
import 'package:duitwise_app/modules/financial_tracking/mybudget_page.dart';
//import 'package:duitwise_app/modules/financial_tracking/budget_allocation_page.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(bottomNavProvider);

    // Pages for the 4 bottom nav destinations
    final pages = [
      const HomePage(),
      const MyBudgetPage(),
      LearningPage(),
      const ProfilePage(),
    ];

    return AppScaffold(
      appBar: DuitWiseAppBar(),
      body: pages[tab],
      navBar: const BottomNavBar(),
    );
  }
}
