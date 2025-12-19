library;

class TransactionModel {
  final String id;
  final String notes;
  final String category;  // must match commitments key e.g. "food"
  final double amount;    // store as positive expense
  final double createdAt;    // millisSinceEpoch

  TransactionModel({
    required this.id,
    required this.notes,
    required this.category,
    required this.amount,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(String id, Map<dynamic, dynamic> data) {
    return TransactionModel(
      id: id,
      notes: (data['notes'] ?? '') as String,
      category: (data['category'] ?? '') as String,
      amount: (data['amount'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] ?? 0.0) as double,
    );
  }

  Map<String, dynamic> toMap() => {
        'notes': notes,
        'category': category,
        'amount': amount,
        'createdAt': createdAt,
      };
}
