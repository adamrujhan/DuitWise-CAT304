//////////////////////////////////////////////////////////
//                 FINANCIAL MODEL
//////////////////////////////////////////////////////////
library;

class FinancialModel {
  final int income;
  final Map<String, int> commitments;
  final bool hasSetupBudget;

  FinancialModel({
    required this.income,
    required this.commitments,
    required this.hasSetupBudget,
  });
 
  // Default empty financial model
  factory FinancialModel.empty() =>
      FinancialModel(income: 0, commitments: {}, hasSetupBudget: false);

  factory FinancialModel.fromMap(Map<String, dynamic> map) {
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

    return FinancialModel(
      income: parseInt(map["income"]),
      commitments: parseCommitments(map["commitments"]),
      hasSetupBudget: map["hasSetupBudget"] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "income": income,
      "commitments": commitments,
      "hasSetupBudget": hasSetupBudget,
    };
  }
}
