import 'package:duitwise_app/data/models/analytics_model.dart';
import 'package:duitwise_app/data/repositories/analytics_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. The Repository Provider (Keeps the repo instance alive)
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

// 2. The Stream Provider (The bridge to the UI)
// NOTE: You need a real UID here. If you have an AuthProvider, use:
// final uid = ref.watch(authProvider).uid;
final analyticsStreamProvider = StreamProvider.autoDispose<AnalyticsModel>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  
  // TODO: Replace 'user_123' with the actual logged-in user's UID
  const String uid = 'user_123'; 
  
  return repository.watchAnalytics(uid);
});