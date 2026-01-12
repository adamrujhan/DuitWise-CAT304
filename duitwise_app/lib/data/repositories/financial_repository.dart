import 'package:duitwise_app/data/models/financial_model.dart';
import 'package:firebase_database/firebase_database.dart';

class FinancialRepository {
  final FirebaseDatabase db = FirebaseDatabase.instance;

  Stream<FinancialModel> watchFinancial(String? uid) {
    final ref = db.ref("users/$uid/financial");

    return ref.onValue.map((event) {
      final raw = event.snapshot.value;

      if (raw == null) {
        return FinancialModel.empty();
      }

      // Cast first → THEN convert
      final map = Map<dynamic, dynamic>.from(raw as Map);

      return FinancialModel.fromMap(Map<String, dynamic>.from(map));
    });
  }

  Future<void> updateFinancial(String? uid, Map<String, dynamic> data) {
    final ref = db.ref("users/$uid/financial");
    return ref.update(data);
  }

  Future<void> addCommitment({
    required String uid,
    required String label,
    required int amount,
  }) {
    final ref = db.ref("users/$uid/financial/commitments");
    return ref.update({label: amount});
  }

  Future<void> deleteCommitment({required String uid, required String label}) {
    final ref = db.ref("users/$uid/financial/commitments/$label");
    return ref.remove();
  }

  Future<void> changeUsedAmount({
    required String uid,
    required String category,
    required double changeBy,
  }) async {
    // 1. Point directly to the specific commitment child node
    final ref = db.ref("users/$uid/financial/used/$category");

    // 2. Run a transaction
    await ref.runTransaction((currentData) {
      // 'currentData' is the value currently in the database (the "pull" step)

      // If data is null (doesn't exist yet), default to 0.0
      final currentDouble = (currentData as num?)?.toDouble() ?? 0.0;

      // Calculate the new total
      final newTotal = currentDouble - changeBy;

      // 3. Commit the success
      return Transaction.success(newTotal);
    });
  }
}
