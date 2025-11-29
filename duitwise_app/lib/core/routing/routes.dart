import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:duitwise_app/modules/auth/view/register_page.dart';
import 'package:duitwise_app/modules/auth/view/sign_in_page.dart';
import 'package:duitwise_app/modules/onboarding/view/start_page.dart';

import 'package:duitwise_app/services/firebase_auth/auth_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state — rebuilds router when user logs in/out
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/signin',

    // ---------- AUTH REDIRECT LOGIC ----------
    redirect: (context, state) {
      final user = authState.value;
      final atAuthPages =
          state.matchedLocation == '/signin' ||
          state.matchedLocation == '/register';

      // User NOT logged in → force to /signin
      if (user == null && !atAuthPages) {
        return '/signin';
      }

      // User logged in → prevent visiting signin/register
      if (user != null && atAuthPages) {
        return '/home';
      }

      return null;
    },

    // ---------- APP ROUTES ----------
    routes: [
      GoRoute(path: '/', builder: (_, _) => const StartPage()),
      GoRoute(path: '/signin', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
      //GoRoute(path: '/home', builder: (_, _) => const HomePage()),
    ],
  );
});