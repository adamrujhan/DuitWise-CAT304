import 'package:firebase_database/firebase_database.dart';
import 'package:duitwise_app/data/models/transaction_model.dart';

class TransactionRepository {
  final FirebaseDatabase db = FirebaseDatabase.instance;

  Stream<List<TransactionModel>> watchTransactions(String? uid) {
    final ref = db.ref("users/$uid/transactions");

    return ref.onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw == null) return <TransactionModel>[];

      final map = Map<dynamic, dynamic>.from(raw as Map);

      final list = map.entries.map((e) {
        final id = e.key.toString();
        final data = Map<dynamic, dynamic>.from(e.value as Map);
        return TransactionModel.fromMap(id, data); // ✅ correct
      }).toList();

      list.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // ✅ correct field
      return list;
    });
  }

  /// Latest N (still live)
  Stream<List<TransactionModel>> watchLatestTransactions({
    required String uid,
    int limit = 6,
  }) {
    final ref = db
        .ref("users/$uid/transactions")
        .orderByChild('createdAt')
        .limitToLast(limit);

    return ref.onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw == null) return <TransactionModel>[];

      final map = Map<dynamic, dynamic>.from(raw as Map);

      final list = map.entries.map((e) {
        final id = e.key.toString();
        final data = Map<dynamic, dynamic>.from(e.value as Map);
        return TransactionModel.fromMap(id, data);
      }).toList();

      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Future<void> addTransaction(String uid, TransactionModel tx) async {
    final ref = db.ref("users/$uid/transactions").push();
    await ref.set(tx.toMap());
  }

  Future<void> updateTransaction(
    String uid,
    String transactionId,
    Map<String, dynamic> data,
  ) {
    final ref = db.ref("users/$uid/transactions/$transactionId");
    return ref.update(data);
  }

  Future<void> deleteTransaction(String uid, String transactionId) {
    final ref = db.ref("users/$uid/transactions/$transactionId");
    return ref.remove();
  }

  // ignore: unintended_html_in_doc_comment
  /// ✅ increment financial/used/<category>
  Future<void> addToUsed({
    required String uid,
    required String category,
    required double amount,
  }) async {
    final ref = db.ref("users/$uid/financial/used/$category");

    await ref.runTransaction((current) {
      final currentNum = (current as num?) ?? 0;
      return Transaction.success(currentNum + amount);
    });
  }
}
