//////////////////////////////////////////////////////////
//                 ANALYTICS MODEL
//////////////////////////////////////////////////////////
library;

class AnalyticsModel {
  final int income;
  final Map<String, int> commitments;

  AnalyticsModel({
    required this.income,
    required this.commitments,
  });
 
  // Default empty analytics model
  factory AnalyticsModel.empty() =>
      AnalyticsModel(income: 0, commitments: {});

  factory AnalyticsModel.fromMap(Map<String, dynamic> map) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Parse commitments map safely
    Map<String, int> parseCommitments(dynamic value) {
      if (value is Map) {
        return value.map((key, val) => MapEntry(key.toString(), parseInt(val)));
      }
      return {};
    }

    return AnalyticsModel(
      income: parseInt(map["income"]),
      commitments: parseCommitments(map["commitments"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "income": income,
      "commitments": commitments,
    };
  }
}
