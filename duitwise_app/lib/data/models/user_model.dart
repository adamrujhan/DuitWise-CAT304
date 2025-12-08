class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  final FinancialModel financial;
  final LearningModel learning;
  final SettingsModel settings;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.financial,
    required this.learning,
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
      learning: LearningModel.fromMap(
        Map<String, dynamic>.from(map["learning"] ?? {}),
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
      "learning": learning.toMap(),
      "settings": settings.toMap(),
    };
  }
}

//////////////////////////////////////////////////////////
//                 FINANCIAL MODEL
//////////////////////////////////////////////////////////

class FinancialModel {
  final int income;
  final int food;
  final int groceries;
  final int transport;
  final int bill;
  final int saving;
  final String transaction; // You had an empty string in the DB export

  FinancialModel({
    required this.income,
    required this.food,
    required this.groceries,
    required this.transport,
    required this.bill,
    required this.saving,
    required this.transaction,
  });

  factory FinancialModel.fromMap(Map<String, dynamic> map) {
    int parseInt(dynamic value) {
      if (value == null) return 0; // default if null
      if (value is int) return value; // already int
      if (value is String) return int.tryParse(value) ?? 0; // convert string to int
      return 0; // fallback
    }

    return FinancialModel(
      income: parseInt(map["income"]),
      food: parseInt(map["food"]),
      groceries: parseInt(["groceries"]),
      transport: parseInt(["transport"]),
      bill: parseInt(["bill"]),
      saving: parseInt(["saving"]),
      transaction: map["transaction"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "income": income,
      "food": food,
      "groceries": groceries,
      "transport": transport,
      "bill": bill,
      "saving": saving,
      "transaction": transaction,
    };
  }
}

//////////////////////////////////////////////////////////
//                 LEARNING MODEL
//////////////////////////////////////////////////////////

class LearningModel {
  final Map<String, bool> completedLessons;
  final Map<String, int> quizScores;

  LearningModel({required this.completedLessons, required this.quizScores});

  factory LearningModel.fromMap(Map<String, dynamic> map) {
    return LearningModel(
      completedLessons: map["completedLessons"] != null
          ? Map<String, bool>.from(map["completedLessons"])
          : {},
      quizScores: map["quizScores"] != null
          ? Map<String, int>.from(map["quizScores"])
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {"completedLessons": completedLessons, "quizScores": quizScores};
  }
}

//////////////////////////////////////////////////////////
//                 SETTINGS MODEL
//////////////////////////////////////////////////////////

class SettingsModel {
  final String language;
  final bool notifications;
  final String theme;

  SettingsModel({
    required this.language,
    required this.notifications,
    required this.theme,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      language: map["language"] ?? "en",
      notifications: map["notifications"] ?? true,
      theme: map["theme"] ?? "light",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "language": language,
      "notifications": notifications,
      "theme": theme,
    };
  }
}
