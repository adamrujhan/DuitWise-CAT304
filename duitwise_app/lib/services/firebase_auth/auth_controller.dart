import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  // ---------- ADD USER TO RTDB ----------
  Future<void> _createUserInDatabase(
    String uid,
    String username,
    String email,
  ) async {
    final db = FirebaseDatabase.instance.ref();

    await db.child("users/$uid").set({
      "name": username,
      "email": email,
      "uid": uid,
      "photoUrl": "",
      "financial": {
        "hasSetupBudget": false,
        "income": 0,
        "food": 0,
        "groceries": 0,
        "transport": 0,
        "bill": 0,
        "saving": 0,
        "transaction": "",
      },
      "learning": {"completedLessons": {}, "quizScores": {}},
      "settings": {"language": "en", "notifications": true, "theme": "light"},
    });
  }

  // ---------- REGISTER ----------
  Future<void> register(String username, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = credential.user!.uid;

      //create user profile in RTDB
      await _createUserInDatabase(uid, username, email);
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

  // ---------- FORGET PASSWORD ----------
  Future<void> changePassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
