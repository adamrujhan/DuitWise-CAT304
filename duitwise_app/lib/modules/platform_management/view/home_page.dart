import 'package:duitwise_app/core/widgets/add_transaction_popup.dart';
import 'package:duitwise_app/core/widgets/recent_activity.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:duitwise_app/modules/platform_management/providers/cumulative_daily_spending_provider.dart';
import 'package:duitwise_app/modules/platform_management/providers/weekly_total_spending_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);
    final uid = userAsync.maybeWhen(data: (u) => u?.uid, orElse: () => null);

    final cumulativeDailySpendingAsync = ref.watch(
      cumulativeDailySpendingProvider(uid),
    );

    final weeklySpendingAsync = ref.watch(weeklyTotalSpendingProvider(uid));

    final financialAsync = ref.watch(financialStreamProvider(uid));

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // Welcome
              userAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text("Error: $e"),
                data: (user) {
                  if (user == null) {
                    return const Text("No user found");
                  }
                  return Column(
                    children: [
                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Welcome, ${user.name}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Spending",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 220,
                                child: cumulativeDailySpendingAsync.when(
                                  loading: () => const SizedBox(
                                    height: 220,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  error: (e, _) => Text('Chart error: $e'),
                                  data: (spots) => LineChart(_chartData(spots)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: weeklySpendingAsync.when(
                            data: (weeklySpending) => Text(
                              "This week spending: RM${weeklySpending.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            error: (e, _) => Text('Weekly spending error: $e'),
                            loading: () => const SizedBox(
                              height: 220,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      const RecentActivityCard(activityNum: 3),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: uid == null
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                final categories = financialAsync.maybeWhen(
                  data: (f) => f.commitments.keys.toList(),
                  orElse: () => <String>[],
                );

                if (categories.isEmpty) return;

                showDialog(
                  context: context,
                  builder: (_) =>
                      AddTransactionPopup(uid: uid, categories: categories),
                );
              },
            ),
    );
  }
}

// ───────────────── Line Chart Config ─────────────────
LineChartData _chartData(List<FlSpot> spots) {
  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(show: false),
    borderData: FlBorderData(show: false),
    lineBarsData: [
      LineChartBarData(
        isCurved: true,
        color: Colors.blue,
        barWidth: 4,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              Colors.blue.withValues(alpha: 0.25),
              Colors.blue.withValues(alpha: 0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        spots: spots,
      ),
    ],
  );
}
