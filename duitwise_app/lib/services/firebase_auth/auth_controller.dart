import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the controller
final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<User?> {
  late final FirebaseAuth _auth;
  StreamSubscription<User?>? _sub;

  @override
  FutureOr<User?> build() {
    _auth = FirebaseAuth.instance;

    // Listen to Firebase auth state changes
    _sub = _auth.authStateChanges().listen((user) {
      // Whenever Firebase emits, update our state
      state = AsyncValue.data(user);
    });

    // Clean up subscription when this notifier is disposed
    ref.onDispose(() {
      _sub?.cancel();
    });

    // Initial value
    return _auth.currentUser;
  }

  // ---------- LOGIN ----------
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // No need to set state here: Firebase stream will emit user
    } on FirebaseAuthException catch (e) {
      // Report error WITHOUT breaking the stream-driven user state
      state = AsyncValue.error(e.message ?? "Login error", StackTrace.current);
    }
  }

  // ---------- REGISTER ----------
  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // Firebase stream will emit new user
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(
        e.message ?? "Registration error",
        StackTrace.current,
      );
    }
  }

  // ---------- LOGOUT ----------
  Future<void> signOut() async {
    await _auth.signOut();
    // Do NOT manually set state to null here.
    // The authStateChanges() stream will emit `null` and update state.
  }
}
