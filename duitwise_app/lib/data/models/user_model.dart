import 'package:duitwise_app/data/models/financial_model.dart';
import 'package:duitwise_app/data/models/settings_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  final FinancialModel financial;
  final SettingsModel settings;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.financial,
    required this.settings,
  });

  // =====================================================
  //                    FROM MAP
  // =====================================================
  factory UserModel.fromMap(Map<String, dynamic> map, {required String uid}) {
    return UserModel(
      uid: map["uid"] ?? 0,
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      photoUrl: map["photoUrl"] ?? "",
      financial: FinancialModel.fromMap(
        Map<String, dynamic>.from(map["financial"] ?? {}),
      ),
      settings: SettingsModel.fromMap(
        Map<String, dynamic>.from(map["settings"] ?? {}),
      ),
    );
  }

  // =====================================================
  //                    TO MAP
  // =====================================================
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "photoUrl": photoUrl,
      "financial": financial.toMap(),
      "settings": settings.toMap(),
    };
  }
}
