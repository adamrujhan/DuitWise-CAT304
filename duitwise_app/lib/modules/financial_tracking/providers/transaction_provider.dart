import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/data/models/transaction_model.dart';
import 'package:duitwise_app/data/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

final transactionsStreamProvider =
    StreamProvider.family<List<TransactionModel>, String>((ref, uid) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchTransactions(uid);
});

final latestTransactionsStreamProvider =
    StreamProvider.family<List<TransactionModel>, String>((ref, uid) {
  final repo = ref.watch(transactionRepositoryProvider);
  return repo.watchLatestTransactions(uid: uid, limit: 6);
});
