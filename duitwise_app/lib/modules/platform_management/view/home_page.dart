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

    final spots = userAsync.when(
      data: (user) {
        if (user == null) return const <FlSpot>[];
        return ref.watch(cumulativeDailySpendingProvider(user.uid));
      },
      loading: () => const <FlSpot>[],
      error: (_, _) => const <FlSpot>[],
    );

    final weeklySpending = userAsync.when(
      data: (user) {
        if (user == null) return 0;
        return ref.watch(weeklyTotalSpendingProvider(user.uid));
      },
      loading: () => 0,
      error: (_, _) => 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7), // Mint green

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // Welcome Card
              userAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
                data: (user) {
                  return RoundedCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Welcome, ${user?.name ?? ''}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              // Dashboard Card (with Chart)
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

              // Weekly spending card
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "This week spending: RM${weeklySpending.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 120), // Scroll spacing above navbar
            ],
          ),
        ),
      ),
    );
  }
}

// linechart
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
