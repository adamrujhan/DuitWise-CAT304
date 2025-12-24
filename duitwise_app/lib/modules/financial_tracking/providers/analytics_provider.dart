import 'package:duitwise_app/data/models/analytics_model.dart';
import 'package:duitwise_app/data/repositories/analytics_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. The Repository Provider (Keeps the repo instance alive)
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

// 2. The Stream Provider (The bridge to the UI)
final analyticsStreamProvider = StreamProvider.family<AnalyticsModel, String?>((ref, uid) {
  final repo = ref.watch(analyticsRepositoryProvider);
  return repo.watchAnalytics(uid);
});