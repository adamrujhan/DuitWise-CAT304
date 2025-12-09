import 'package:duitwise_app/data/models/analytics_model.dart';
import 'package:firebase_database/firebase_database.dart';

class AnalyticsRepository {
  final FirebaseDatabase db = FirebaseDatabase.instance;

  Stream<AnalyticsModel> watchAnalytics(String uid) {
    // **MODIFIED to read financial data**
    final ref = db.ref("users/$uid/financial"); 

    return ref.onValue.map((event) {
      final raw = event.snapshot.value;

      if (raw == null) {
        return AnalyticsModel.empty();
      }

      final map = Map<dynamic, dynamic>.from(raw as Map);

      // This safely maps the financial data (income, commitments, hasSetupBudget) 
      // into the AnalyticsModel (income, commitments).
      return AnalyticsModel.fromMap(Map<String, dynamic>.from(map));
    });
  }

  Future<void> updateAnalytics(String uid, Map<String, dynamic> data) {
    // Reference the 'analytics' node under the user's UID
    // NOTE: This remains on the 'analytics' node for any potential dedicated analytics logging.
    final ref = db.ref("users/$uid/analytics"); 
    return ref.update(data);
  }
}