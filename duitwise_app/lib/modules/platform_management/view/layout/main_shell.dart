import 'package:duitwise_app/modules/analytics/view/analytics_page.dart';
import 'package:duitwise_app/modules/financial_literacy/views/fin_lit_page.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/duitwise_appbar.dart';
import 'package:duitwise_app/modules/user_profile/view/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:duitwise_app/modules/platform_management/view/layout/app_scaffold.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/bottom_nav_bar.dart';

import 'package:duitwise_app/modules/platform_management/providers/bottom_nav_provider.dart';

import 'package:duitwise_app/services/firebase_auth/uid_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';

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
    // Step 1: Read authenticated UID
    final uid = ref.watch(uidProvider);

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("Not authenticated")),
      );
    }

    // Step 2: Listen to real-time user profile
    final userAsync = ref.watch(userStreamProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text("Error loading profile: $err")),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("No user profile found")),
          );
        }

        // Step 3: Read selected bottom navigation tab
        final tab = ref.watch(bottomNavProvider);

        // Step 4: Inject user into pages that require it
        final pages = [
          HomePage(),
          BudgetSetupPage(),
          AnalyticsPage(),
          LearningPage(),
          ProfilePage(user: user),
        ];

        return AppScaffold(
          appBar: DuitWiseAppBar(),
          body: pages[tab],
          navBar: const BottomNavBar(),
        );
      },
    );
  }
}
