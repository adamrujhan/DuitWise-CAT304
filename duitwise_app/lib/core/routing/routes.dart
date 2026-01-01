import 'package:duitwise_app/modules/analytics/view/analytics_page.dart';
import 'package:duitwise_app/modules/financial_literacy/views/learning_page.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:duitwise_app/modules/financial_tracking/view/budget_page.dart';
import 'package:duitwise_app/modules/financial_tracking/view/mybudget_page.dart';
import 'package:duitwise_app/modules/platform_management/view/admin_dashboard_page.dart';
import 'package:duitwise_app/modules/platform_management/view/home_page.dart';

import 'package:duitwise_app/modules/onboarding/view/start_page.dart';
import 'package:duitwise_app/modules/auth/view/sign_in_page.dart';
import 'package:duitwise_app/modules/auth/view/register_page.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/main_shell.dart';
import 'package:duitwise_app/modules/financial_tracking/view/budget_setup_page.dart';
import 'package:duitwise_app/modules/financial_tracking/view/budget_allocation_page.dart';
import 'package:duitwise_app/modules/financial_tracking/view/activity_page.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
import 'package:duitwise_app/modules/user_profile/view/user_profile.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:duitwise_app/services/firebase_auth/auth_controller.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',

    // ==================================
    // REDIRECT LOGIC
    // ==================================
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final User? user = authState.asData?.value;
      const publicRoutes = ['/', '/signin', '/register'];
      final isPublic = publicRoutes.contains(state.matchedLocation);

      if (user == null) {
        return isPublic ? null : '/signin';
      }

      // ignore: unnecessary_null_comparison
      if (user != null && isPublic) {
        return '/home';
      }

      return null;
    },

    // ==================================
    // ROUTE TREE
    // ==================================
    routes: [
      // ---------- PUBLIC ROUTES ----------
      GoRoute(path: '/', builder: (_, _) => const StartPage()),
      GoRoute(path: '/signin', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),

      // ---------- PROTECTED ROUTES ----------
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // -------------------------------
          // HOME
          // -------------------------------
          GoRoute(
            path: '/home',
            builder: (context, _) {
              return Consumer(
                builder: (context, ref, _) {
                  final userAsync = ref.watch(userStreamProvider);

                  return userAsync.when(
                    loading: () => const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
                    data: (user) {
                      if (user!.isAdmin) {
                        return const AdminDashboardPage();
                      }

                      return const HomePage();
                    },
                  );
                },
              );
            },
          ),

          // -------------------------------
          // BUDGET
          // -------------------------------
          GoRoute(
            path: '/budget',
            builder: (context, state) => Consumer(
              builder: (context, ref, _) {
                final uid = ref.read(authControllerProvider).value?.uid;
                if (uid == null) {
                  return const Scaffold(body: Text("No user logged in"));
                }

                final financialAsync = ref.watch(financialStreamProvider(uid));

                return financialAsync.when(
                  data: (financial) {
                    // If budget is setup, go straight to MyBudgetPage
                    return financial.hasSetupBudget
                        ? BudgetPage()
                        : BudgetSetupPage();
                  },
                  loading: () => const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) =>
                      Scaffold(body: Center(child: Text("Error: $err"))),
                );
              },
            ),
            routes: [
              GoRoute(
                path: 'allocation',
                name: 'budget_allocation',
                builder: (context, state) {
                  return const BudgetAllocationPage();
                },
              ),
              GoRoute(
                path: 'mybudget',
                name: 'budget_mybudget',
                builder: (context, state) {
                  return const MyBudgetPage();
                },
              ),
              GoRoute(
                path: 'activity',
                name: 'budget_activity',
                builder: (context, state) {
                  return const ActivityPage();
                },
              ),
            ],
          ),

          // -------------------------------
          // ANALYTICS
          // -------------------------------
          GoRoute(path: '/analytics', builder: (_, _) => const AnalyticsPage()),

          // -------------------------------
          // LEARNING / FINANCIAL LITERACY
          // -------------------------------
          GoRoute(path: '/learn', builder: (_, _) => LearningPage()),

          // -------------------------------
          // PROFILE
          // -------------------------------
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              return ProfilePage();
            },
          ),
        ],
      ),
    ],
  );
});
