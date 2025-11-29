import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, User?>(AuthController.new);

class AuthController extends AsyncNotifier<User?> {
  late final FirebaseAuth _auth;

  @override
  FutureOr<User?> build() {
    _auth = FirebaseAuth.instance;

    // listen to auth changes
    _auth.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    });

    // initial state
    return _auth.currentUser;
  }

  // ---------- LOGIN ----------
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e.message ?? "Login error", StackTrace.current);
    }
  }

  // ---------- REGISTER ----------
  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e.message ?? "Registration error", StackTrace.current);
    }
  }

  // ---------- LOGOUT ----------
  Future<void> signOut() async {
    await _auth.signOut();
    state = const AsyncValue.data(null);
  }
}
