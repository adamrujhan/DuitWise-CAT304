import 'package:duitwise_app/modules/financial_tracking/providers/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cumulativeDailySpendingProvider = Provider.family<List<FlSpot>, String?>((
  ref,
  uid,
) {
  final txAsync = ref.watch(transactionsStreamProvider(uid));

  return txAsync.when(
    data: (txs) {
      final Map<DateTime, double> dailyTotals = {};

      for (final tx in txs) {
        final dt = DateTime.fromMillisecondsSinceEpoch(tx.createdAt.toInt());
        final dayKey = DateTime(dt.year, dt.month, dt.day);

        dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + tx.amount;
      }

      final days = dailyTotals.keys.toList()..sort();

      double cumulative = 0;
      return List.generate(days.length, (i) {
        cumulative += dailyTotals[days[i]]!;
        return FlSpot(i.toDouble(), cumulative);
      });
    },
    loading: () => const [],
    error: (_, _) => const [],
  );
});
