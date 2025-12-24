import 'package:duitwise_app/core/widgets/recent_activity.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';
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

    final spots = ref.watch(cumulativeDailySpendingProvider(uid));

    final weeklySpending = ref.watch(weeklyTotalSpendingProvider(uid));

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
                                child: LineChart(_chartData(spots)),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "This week spending: RM${weeklySpending.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
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
