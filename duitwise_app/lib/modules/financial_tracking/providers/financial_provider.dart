import 'package:duitwise_app/data/models/financial_model.dart';
import 'package:duitwise_app/data/repositories/financial_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final financialRepositoryProvider = Provider<FinancialRepository>((ref) {
  return FinancialRepository();
});

final financialStreamProvider = StreamProvider.family<FinancialModel, String?>((ref, uid) {
  final repo = ref.watch(financialRepositoryProvider);
  return repo.watchFinancial(uid);
});
