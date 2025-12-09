import 'package:firebase_database/firebase_database.dart';

/// Service layer for all Firebase Realtime Database operations.
/// This file should contain ONLY low-level DB logic.
/// No mapping, no models, no business rules.
/// Repositories will use this class to transform raw data.
class FirebaseRealtimeService {
  FirebaseRealtimeService._internal();

  /// Singleton pattern (optional but recommended)
  static final FirebaseRealtimeService instance =
      FirebaseRealtimeService._internal();

  /// Firebase DB reference
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // ============================================================
  //                         USERS CRUD
  // ============================================================

  /// CREATE or OVERWRITE a user node
  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.child("users/$uid").set(data);
  }

  /// UPDATE user (merges fields)
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.child("users/$uid").update(data);
  }

  /// DELETE user
  Future<void> deleteUser(String uid) async {
    await _db.child("users/$uid").remove();
  }

  /// GET single user snapshot
  Future<Map<String, dynamic>?> getUser(String uid) async {
    final snapshot = await _db.child("users/$uid").get();
    if (!snapshot.exists) return null;

    return _convertSnapshot(snapshot.value);
  }

  /// STREAM user (real-time updates)
  Stream<Map<String, dynamic>> userStream(String uid) {
    return _db.child("users/$uid").onValue.map(
      (event) => _convertSnapshot(event.snapshot.value) ?? {},
    );
  }

  // ============================================================
  //                    SUB-SECTIONS (Optional Helpers)
  // ============================================================

  /// Update only the financial section
  Future<void> updateFinancial(String uid, Map<String, dynamic> data) async {
    await _db.child('users/$uid/financial').update(data);
  }

  /// Update only the learning section
  Future<void> updateLearning(String uid, Map<String, dynamic> data) async {
    await _db.child("lessons/1").update(data);
  }

  /// Update only the settings section
  Future<void> updateSettings(String uid, Map<String, dynamic> data) async {
    await _db.child("users/$uid/settings").update(data);
  }

  // ============================================================
  //                          HELPERS
  // ============================================================

  // ignore: unintended_html_in_doc_comment
  /// Converts dynamic Firebase snapshot data to Map<String, dynamic>
  Map<String, dynamic>? _convertSnapshot(dynamic value) {
    if (value == null) return null;

    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }

    return null;
  }
}
