import 'package:duitwise_app/modules/analytics/view/analytics_page.dart';
import 'package:duitwise_app/modules/financial_literacy/views/learning_page.dart';
import 'package:duitwise_app/modules/platform_management/view/home_page.dart';

import 'package:duitwise_app/modules/onboarding/view/start_page.dart';
import 'package:duitwise_app/modules/auth/view/sign_in_page.dart';
import 'package:duitwise_app/modules/auth/view/register_page.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/main_shell.dart';
import 'package:duitwise_app/modules/financial_tracking/view/budget_setup_page.dart';
import 'package:duitwise_app/modules/financial_tracking/view/budget_allocation_page.dart';
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
    // REDIRECT LOGIC (unchanged)
    // ==================================
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final User? user = authState.asData?.value;
      const publicRoutes = ['/', '/signin', '/register'];
      final isPublic = publicRoutes.contains(state.matchedLocation);

      if (user == null) {
        return isPublic ? null : '/signin';
      }

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
          // TAB: HOME
          // -------------------------------
          GoRoute(
            path: '/home',
            builder: (_, _) => const HomePage(),
          ),

          // -------------------------------
          // TAB: BUDGET (Root)
          // -------------------------------
          GoRoute(
            path: '/budget',
            builder: (_, _) {
              final user = ref.read(userStreamProvider).value;
              if (user == null) return const Scaffold(body: Text("Loading user..."));
              return BudgetSetupPage(user: user);
            },

            // Nested routes under Budget
            routes: [
              GoRoute(
                path: 'allocation',
                name: 'budget_allocation',
                builder: (context, state) {
                  final user = ref.read(userStreamProvider).value;
                  if (user == null) return const Scaffold(body: Text("No user found"));
                  return BudgetAllocationPage(user: user);
                },
              ),
            ],
          ),

          // -------------------------------
          // TAB: ANALYTICS
          // -------------------------------
          GoRoute(
            path: '/analytics',
            builder: (_, _) => const AnalyticsPage(),
          ),

          // -------------------------------
          // TAB: LEARNING / FINANCIAL LITERACY
          // -------------------------------
          GoRoute(
            path: '/learn',
            builder: (_, _) =>  LearningPage(),
          ),

          // -------------------------------
          // TAB: PROFILE
          // -------------------------------
          GoRoute(
            path: '/profile',
            builder: (_, _) {
              final user = ref.read(userStreamProvider).value;
              if (user == null) return const Scaffold(body: Text("No user profile"));
              return ProfilePage(user: user);
            },
          ),
        ],
      ),
    ],
  );
});
