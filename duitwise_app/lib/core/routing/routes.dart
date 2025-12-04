import 'package:duitwise_app/modules/platform_management/view/home_page.dart';

import 'package:duitwise_app/modules/onboarding/view/start_page.dart';
import 'package:duitwise_app/modules/auth/view/sign_in_page.dart';
import 'package:duitwise_app/modules/auth/view/register_page.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/main_shell.dart';
import 'package:duitwise_app/modules/financial_tracking/view/budget_setup_page.dart';
import 'package:duitwise_app/modules/financial_tracking/view/budget_allocation_page.dart';
import 'package:duitwise_app/data/models/user_model.dart';

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

    redirect: (context, state) {
      if (authState.isLoading) return null;
      final User? user = authState.asData?.value;

      const publicRoutes = ['/', '/signin', '/register'];

      final isPublic = publicRoutes.contains(state.matchedLocation);

      // NOT LOGGED IN → block protected routes
      if (user == null) {
        if (isPublic) return null;
        return '/signin';
      }

      // LOGGED IN → block sign in / register
      // ignore: unnecessary_null_comparison
      if (user != null && isPublic) {
        return '/home';
      }

      return null;
    },

    routes: [
      // ---------------------------
      // PUBLIC ROUTES (No Shell)
      // ---------------------------
      GoRoute(path: '/', builder: (_, _) => const StartPage()),
      GoRoute(path: '/signin', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),

      // ---------------------------
      // PROTECTED APP (Shell)
      // ---------------------------
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),

        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomePage()),

          // Add BudgetAllocationPage route
          GoRoute(
            path: '/budget-setup',
            builder: (context, state) {
              final user = state.extra as UserModel; // Retrieve user
              return BudgetSetupPage(user: user);
            },
          ),
          
          GoRoute(
            path: '/budget-allocation',
            builder: (context, state) {
              final user = state.extra as UserModel; // Retrieve user
              return BudgetAllocationPage(user: user);
            },
          ),
        ],
      ),
    ],
  );
});
