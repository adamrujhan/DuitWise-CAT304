import 'package:duitwise_app/modules/analytics/view/analytics_page.dart';
import 'package:duitwise_app/modules/financial_literacy/views/learning_page.dart';
import 'package:duitwise_app/modules/financial_tracking/view/budget_setup_page.dart';
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

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Step 1: Check authentication
    final uid = ref.watch(uidProvider);

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("Not authenticated")),
      );
    }

    // Step 2: Stream user profile
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

        // Step 3: Current selected nav tab
        final tab = ref.watch(bottomNavProvider);

        // Step 4: Switch-case page selector
        Widget page;

        switch (tab) {
          case 0:
            page = const HomePage();
            break;

          case 1:
            page = BudgetSetupPage(user: user);
            break;

          case 2:
            page = const AnalyticsPage();
            break;

          case 3:
            page =  LearningPage();
            break;

          case 4:
            page = ProfilePage(user: user);
            break;

          default:
            page = const HomePage();
        }

        // Step 5: Render layout scaffold
        return AppScaffold(
          appBar: const DuitWiseAppBar(),
          body: page,
          navBar: const BottomNavBar(),
        );
      },
    );
  }
}