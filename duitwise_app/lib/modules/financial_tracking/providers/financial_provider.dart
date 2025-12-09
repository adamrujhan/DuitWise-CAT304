import 'package:duitwise_app/data/repositories/financial_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final financialRepositoryProvider = Provider<FinancialRepository>((ref) {
  return FinancialRepository();
});
