
import 'package:duitwise_app/data/services/firebase_realtime_service.dart';
import 'package:duitwise_app/data/models/user_model.dart';

/// Repository responsible for converting raw Firebase data into domain models.
/// This ensures the rest of your app never directly deals with Firebase formats.
class UserRepository {
  final FirebaseRealtimeService _service = FirebaseRealtimeService.instance;

  // ======================================================
  //                     FETCH USER
  // ======================================================

  /// Fetch user once (non-realtime)
  Future<UserModel?> fetchUser(String uid) async {
    final rawData = await _service.getUser(uid);
    if (rawData == null) return null;

    return UserModel.fromMap(rawData, uid: '');
  }

  /// Stream realtime user updates
  Stream<UserModel?> watchUser(String uid) {
    return _service.userStream(uid).map((rawData) {
      if (rawData.isEmpty) return null;
      return UserModel.fromMap(rawData, uid: '');
    });
  }

  // ======================================================
  //                     UPDATE USER
  // ======================================================

  /// Update multiple user fields at once
  Future<void> updateUser(String uid, Map<String, dynamic> data) {
    return _service.updateUser(uid, data);
  }

  /// Update only the financial info
  Future<void> updateFinancial(String uid, Map<String, dynamic> data) {
    return _service.updateFinancial(uid, data);
  }

  /// Update learning progress
  Future<void> updateLearning(String uid, Map<String, dynamic> data) {
    return _service.updateLearning(uid, data);
  }

  /// Update settings (theme, language, notifications)
  Future<void> updateSettings(String uid, Map<String, dynamic> data) {
    return _service.updateSettings(uid, data);
  }

  // ======================================================
  //                      CREATE USER
  // ======================================================

  Future<void> createUser(String uid, UserModel user) {
    return _service.createUser(uid, user.toMap());
  }

  // ======================================================
  //                      DELETE USER
  // ======================================================

  Future<void> deleteUser(String uid) {
    return _service.deleteUser(uid);
  }
}
