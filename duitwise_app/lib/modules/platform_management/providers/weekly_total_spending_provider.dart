import 'package:duitwise_app/data/models/transaction_model.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weeklyTotalSpendingProvider = StreamProvider.family<double, String?>((
  ref,
  uid,
) {
  if (uid == null) return const Stream.empty();

  return ref
      .watch(transactionsStreamProvider(uid))
      .when(
        data: (txs) => Stream.value(_toWeeklySpending(txs)),
        loading: () => const Stream.empty(),
        error: (_, _) => const Stream.empty(),
      );
});

double _toWeeklySpending(List<TransactionModel> txs) {
  final now = DateTime.now();

  // Start of week: Monday 00:00
  final startOfWeek = DateTime(
    now.year,
    now.month,
    now.day - (now.weekday - DateTime.monday),
  );

  // End of week: Sunday 23:59:59
  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  double total = 0;

  for (final tx in txs) {
    final txTime = DateTime.fromMillisecondsSinceEpoch(tx.createdAt.toInt());

    if (txTime.isAfter(startOfWeek) && txTime.isBefore(endOfWeek)) {
      total += tx.amount;
    }
  }

  return total;
}
