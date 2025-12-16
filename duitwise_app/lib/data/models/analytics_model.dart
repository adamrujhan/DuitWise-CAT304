class AnalyticsModel {
  final int income;
  final Map<String, int> commitments; // Budget Allocated
  final Map<String, double> used;     // Actual Spending (NEW)

  AnalyticsModel({
    required this.income,
    required this.commitments,
    required this.used,
  });

  factory AnalyticsModel.empty() =>
      AnalyticsModel(income: 0, commitments: {}, used: {});

  factory AnalyticsModel.fromMap(Map<String, dynamic> map) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }
    
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    Map<String, int> parseCommitments(dynamic value) {
      if (value is Map) {
        return value.map((key, val) => MapEntry(key.toString(), parseInt(val)));
      }
      return {};
    }

    // NEW: Parse the 'used' map
    Map<String, double> parseUsed(dynamic value) {
      if (value is Map) {
        return value.map((key, val) => MapEntry(key.toString(), parseDouble(val)));
      }
      return {};
    }

    return AnalyticsModel(
      income: parseInt(map["income"]),
      commitments: parseCommitments(map["commitments"]),
      used: parseUsed(map["used"]), // Fetch actual spending
    );
  }
}