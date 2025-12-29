import 'package:duitwise_app/data/repositories/financial_repository.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancialController extends AsyncNotifier<void> {
  late final FinancialRepository _repo;

  @override
  Future<void> build() async {
    _repo = ref.read(financialRepositoryProvider);
  }

  Future<void> updateFinancial(
    String? uid,
    Map<String, dynamic> newData,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.updateFinancial(uid, newData));
  }

  Future<void> addCommitment({
    required String uid,
    required String label,
    required int amount,
  }) {
    return _repo.addCommitment(uid: uid, label: label, amount: amount);
  }
}
