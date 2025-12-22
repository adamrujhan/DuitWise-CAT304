import 'package:duitwise_app/modules/financial_tracking/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weeklyTotalSpendingProvider =
    Provider.family<double, String>((ref, uid) {
  final txAsync = ref.watch(transactionsStreamProvider(uid));

  return txAsync.when(
    data: (txs) {
      final now = DateTime.now();

      // Start of week: Monday 00:00
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day - (now.weekday - DateTime.monday),
      );

      // End of week: Sunday 23:59:59
      final endOfWeek = startOfWeek.add(
        const Duration(days: 7),
      );

      double total = 0;

      for (final tx in txs) {
        final txTime =
            DateTime.fromMillisecondsSinceEpoch(tx.createdAt.toInt());

        if (txTime.isAfter(startOfWeek) && txTime.isBefore(endOfWeek)) {
          total += tx.amount;
        }
      }

      return total;
    },
    loading: () => 0,
    error: (_, _) => 0,
  );
});
