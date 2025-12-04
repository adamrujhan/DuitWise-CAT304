import 'package:duitwise_app/data/services/firebase_realtime_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetServiceProvider = Provider<FirebaseRealtimeService>((ref) {
  return FirebaseRealtimeService.instance;
});
