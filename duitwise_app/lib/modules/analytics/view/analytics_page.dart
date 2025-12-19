import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/analytics_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userStreamProvider).value;
    final uid = user?.uid;
    // 1. WATCH THE DATA STREAM
    // This will now trigger a rebuild whenever the financial data changes in Firebase
    final analyticsAsync = ref.watch(analyticsStreamProvider(uid));

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: analyticsAsync.when(
          // LOADING STATE
          loading: () => const Center(child: CircularProgressIndicator()),

          // ERROR STATE
          error: (err, stack) => Center(child: Text('Error: $err')),

          // DATA LOADED STATE
          data: (data) {
            // 2. CALCULATE TOTALS
            final totalIncome = data.income;
            // Sum all commitment values
            final totalSpent = data.used.values.fold(
              0.0,
              (sum, item) => sum + item,
            );

            // 3. Calculate Remaining
            // totalSpent is now a double, so remaining will be a double too
            final remaining = totalIncome - totalSpent;

            // Prepare dynamic colors for categories

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // --- HEADER ---
                  RoundedCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        "Welcome to Spending Analytics!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // --- PIE CHART SECTION ---
                  // Only show if there is data to display
                  if (totalSpent > 0) ...[
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Distribution",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomPaint(
                                  painter: PieChartPainter(
                                    // Map commitments to PieSegments
                                    segments: data.commitments.entries
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          // final index = entry.key; // You don't need index anymore
                                          final category = entry.value.key;
                                          final usedAmount =
                                              data.used[category] ?? 0.0;

                                          // ... percentage calculation ...
                                          final percentage = totalSpent == 0
                                              ? 0.0
                                              : (usedAmount / totalSpent);

                                          return PieSegment(
                                            // NEW: Get color by Name, not index
                                            color: _getCategoryColor(category),
                                            percentage: percentage,
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Dynamic Legend
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: data.commitments.keys.map((
                                categoryName,
                              ) {
                                return _buildLegendItem(
                                  _getCategoryColor(
                                    categoryName,
                                  ), // NEW: Get color by Name
                                  categoryName,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ] else ...[
                    // 2. IF NO SPENDING: SHOW MESSAGE CARD
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 20,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 48,
                                color: Colors.teal.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "You have not spent anything yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Track your expenses to see analytics.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  // --- SPENDING DETAILS SECTION ---
                  RoundedCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Spending Analytics",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // STATS ROW
                          RoundedCard(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  _buildStatRow(
                                    "Total Budget",
                                    "RM ${totalIncome.toStringAsFixed(2)}",
                                    Colors.blue,
                                  ),
                                  const Divider(height: 24),
                                  _buildStatRow(
                                    "Total Spent",
                                    "RM ${totalSpent.toStringAsFixed(2)}",
                                    Colors.red,
                                  ),
                                  const Divider(height: 24),
                                  _buildStatRow(
                                    "Remaining",
                                    "RM ${remaining.toStringAsFixed(2)}",
                                    Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            "Breakdown",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // DYNAMIC CATEGORY BARS
                          ...data.commitments.entries.toList().asMap().entries.map((
                            entry,
                          ) {
                            final category = entry.value.key;
                            final limit = entry
                                .value
                                .value; // The Budget Limit (e.g., 450)

                            // Fetch the used amount for this category (default to 0.0 if missing)
                            final used = data.used[category] ?? 0.0;

                            // Calculate percentage: Used / Limit
                            // (e.g., 68.50 / 450 = 0.15)
                            final percentage = limit == 0
                                ? 0.0
                                : (used / limit);

                            // Cap percentage at 1.0 (100%) so the bar doesn't overflow if over budget
                            final displayPercentage = percentage > 1.0
                                ? 1.0
                                : percentage;

                            return Column(
                              children: [
                                _buildCategoryBar(
                                  category,
                                  used,
                                  limit,
                                  displayPercentage,
                                  _getCategoryColor(
                                    category,
                                  ), // NEW: Get color by Name
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }),

                          if (data.commitments.isEmpty)
                            const Text("No spending data available yet."),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBar(
    String label,
    double used,
    int limit,
    double percentage,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              "RM ${used.toStringAsFixed(2)} of RM $limit",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[200],
          color: color,
          borderRadius: BorderRadius.circular(8),
          minHeight: 8,
        ),
      ],
    );
  }

  Color _getCategoryColor(String categoryName) {
    final List<MaterialColor> distinctColors = Colors.primaries;
    final int index = categoryName.hashCode.abs() % distinctColors.length;
    return distinctColors[index];
  }
}

// --- PAINTER CLASSES ---
class PieSegment {
  final Color color;
  final double percentage;
  PieSegment({required this.color, required this.percentage});
}

class PieChartPainter extends CustomPainter {
  final List<PieSegment> segments;
  PieChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double startAngle = -pi / 2;

    for (var segment in segments) {
      final sweepAngle = 2 * pi * segment.percentage;
      paint.color = segment.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
