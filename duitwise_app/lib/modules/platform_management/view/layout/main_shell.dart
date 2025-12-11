import 'package:duitwise_app/modules/platform_management/view/layout/app_scaffold.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/bottom_nav_bar.dart';
import 'package:duitwise_app/modules/platform_management/view/layout/duitwise_appbar.dart';
import 'package:duitwise_app/services/firebase_auth/uid_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Auth check
    final uid = ref.watch(uidProvider);
    if (uid == null) {
      return const Scaffold(body: Center(child: Text("Not authenticated")));
    }

    // 2. Load user profile
    final userAsync = ref.watch(userStreamProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) =>
          Scaffold(body: Center(child: Text("Error loading profile: $err"))),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("No user profile found")),
          );
        }

        // 3. Render Shell Layout
        return AppScaffold(
          appBar: const DuitWiseAppBar(),
          body: child, // <-- THIS IS NOW THE ACTIVE PAGE FROM GOROUTER
          navBar: const BottomNavBar(),
        );
      },
    );
  }
}
