import 'package:duitwise_app/modules/learning/view/learning_page.dart';
import 'package:duitwise_app/modules/platform_management/view/home_page.dart';
//import 'package:duitwise_app/modules/financial_tracking/budget_page.dart';
import 'package:duitwise_app/modules/financial_tracking/budget_setup_page.dart';


import 'package:duitwise_app/modules/onboarding/view/start_page.dart';
import 'package:duitwise_app/modules/auth/view/sign_in_page.dart';
import 'package:duitwise_app/modules/auth/view/register_page.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/main_shell.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:duitwise_app/services/firebase_auth/auth_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',

    redirect: (context, state) {
      final User? user = authState.asData?.value;

      const publicRoutes = [
        '/',
        '/signin',
        '/register',
      ];

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
          GoRoute(
            path: '/home',
            builder: (_, _) => const HomePage(),
          ),
          GoRoute(
            path: '/budget',
            builder: (_, _) => const BudgetSetupPage(),
          ), 
          GoRoute(
            path: '/learn',
            builder: (_, _) => const LearningPage(),
          ),
          // GoRoute(
          //   path: '/profile',
          //   builder: (_, _) => const ProfilePage(),
          // ),
        ],
      ),
    ],
  );
});
