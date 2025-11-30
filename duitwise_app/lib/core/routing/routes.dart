import 'package:duitwise_app/modules/financial_tracking/budget_page.dart';
import 'package:duitwise_app/modules/platform_management/view/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:duitwise_app/modules/auth/view/register_page.dart';
import 'package:duitwise_app/modules/auth/view/sign_in_page.dart';
import 'package:duitwise_app/modules/onboarding/view/start_page.dart';

import 'package:duitwise_app/services/firebase_auth/auth_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state — rebuilds router when user logs in/out
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',

    redirect: (context, state) {
      final User? user = authState.asData?.value;

      // Public pages everyone can access
      const publicRoutes = [
        '/', // Start page
        '/signin',
        '/register',
      ];

      final isPublic = publicRoutes.contains(state.matchedLocation);

      // -------------------------
      // USER NOT LOGGED IN
      // -------------------------
      if (user == null) {
        // Allow staying on public pages
        if (isPublic) return null;

        // Block all protected pages (e.g. /home)
        return '/signin';
      }

      // -------------------------
      // USER LOGGED IN
      // -------------------------
      // ignore: unnecessary_null_comparison
      if (user != null && isPublic) {
        return '/home';
      }

      return null;
    },

    // ---------- APP ROUTES ----------
    routes: [
      GoRoute(path: '/', builder: (_, _) => const StartPage()),
      GoRoute(path: '/signin', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
      GoRoute(path: '/home', builder: (_, _) => const HomePage()),
      GoRoute(path: '/budget', builder: (_, _) => const BudgetPage()),
    ],
  );
});
