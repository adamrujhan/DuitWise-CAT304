// FINANCIAL MODEL
library;

class FinancialModel {
  final int income;
  final Map<String, int> commitments;     // allocated
  final Map<String, double> used;         // used per category
  final bool hasSetupBudget;

  FinancialModel({
    required this.income,
    required this.commitments,
    required this.used,
    required this.hasSetupBudget,
  });

  factory FinancialModel.empty() => FinancialModel(
        income: 0,
        commitments: {},
        used: {},
        hasSetupBudget: false,
      );

  factory FinancialModel.fromMap(Map<String, dynamic> map) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    Map<String, int> parseCommitments(dynamic value) {
      if (value is Map) {
        return value.map(
          (key, val) => MapEntry(key.toString(), parseInt(val)),
        );
      }
      return {};
    }

    Map<String, double> parseUsed(dynamic value) {
      if (value is Map) {
        return value.map(
          (key, val) => MapEntry(key.toString(), parseDouble(val)),
        );
      }
      return {};
    }

    return FinancialModel(
      income: parseInt(map["income"]),
      commitments: parseCommitments(map["commitments"]),
      used: parseUsed(map["used"]), // ✅ financial/used in RTDB
      hasSetupBudget: map["hasSetupBudget"] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "income": income,
      "commitments": commitments,
      "used": used, // ✅ include used
      "hasSetupBudget": hasSetupBudget,
    };
  }
}
