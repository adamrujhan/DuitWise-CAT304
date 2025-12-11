import 'package:duitwise_app/services/firebase_auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global provider that exposes the authenticated user's UID.
/// Returns null if user is not logged in.
final uidProvider = Provider<String?>((ref) {
  final authState = ref.watch(authControllerProvider);

  return authState.value?.uid;
});
