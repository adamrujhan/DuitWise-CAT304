import 'package:duitwise_app/modules/onboarding/view/start_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const StartPage(),
    ),
  ],
);
