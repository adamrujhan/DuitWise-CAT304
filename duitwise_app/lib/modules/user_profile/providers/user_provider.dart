import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/data/repositories/user_repository.dart';
import 'package:duitwise_app/services/firebase_auth/uid_provider.dart';
import 'package:duitwise_app/data/models/user_model.dart';

/// Provides the UserRepository instance
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});


/// STREAM Provider → listens to real-time updates from Firebase Realtime Database
final userStreamProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final uid = ref.watch(uidProvider);

  // If user is not logged in, return empty stream
  if (uid == null) {
    return const Stream.empty();
  }

  final repo = ref.watch(userRepositoryProvider);
  return repo.watchUser(uid); // real-time stream
});


/// FUTURE Provider → fetches user data once (non real-time)
final userFutureProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final uid = ref.watch(uidProvider);

  if (uid == null) return null;

  final repo = ref.watch(userRepositoryProvider);
  return repo.fetchUser(uid);
});
