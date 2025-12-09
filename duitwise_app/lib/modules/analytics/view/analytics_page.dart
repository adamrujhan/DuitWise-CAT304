import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/data/models/analytics_model.dart';
// FIX: Use 'package:' and remove '/lib/'
import 'package:duitwise_app/modules/financial_tracking/providers/analytics_provider.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. WATCH THE DATA STREAM
    // This will now trigger a rebuild whenever the financial data changes in Firebase
    final analyticsAsync = ref.watch(analyticsStreamProvider);

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
            final totalSpent = data.commitments.values.fold(0, (sum, item) => sum + item);
            final remaining = totalIncome - totalSpent;
            
            // Prepare dynamic colors for categories
            final List<Color> palette = [
              Colors.orange, Colors.purple, Colors.teal, Colors.blue, Colors.red, Colors.green
            ];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  
                  // --- HEADER ---
                  RoundedCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: const Text(
                        "Welcome to Spending Analytics!",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // --- PIE CHART SECTION ---
                  // Only show if there is data to display
                  if (data.commitments.isNotEmpty) ...[
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Distribution", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomPaint(
                                  painter: PieChartPainter(
                                    // Map commitments to PieSegments
                                    segments: data.commitments.entries.toList().asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final value = entry.value.value;
                                      // Prevent division by zero
                                      final percentage = totalSpent == 0 ? 0.0 : value / totalSpent;
                                      
                                      return PieSegment(
                                        color: palette[index % palette.length],
                                        percentage: percentage,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Dynamic Legend
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: data.commitments.keys.toList().asMap().entries.map((entry) {
                                final index = entry.key;
                                final name = entry.value;
                                return _buildLegendItem(palette[index % palette.length], name);
                              }).toList(),
                            ),
                          ],
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
                          const Text("Spending Analytics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 16),

                          // STATS ROW
                          RoundedCard(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildStatRow("Total Budget", "RM $totalIncome", Colors.blue),
                                  const Divider(height: 24),
                                  _buildStatRow("Total Spent", "RM $totalSpent", Colors.red),
                                  const Divider(height: 24),
                                  _buildStatRow("Remaining", "RM $remaining", Colors.green),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Text("Breakdown", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          
                          // DYNAMIC CATEGORY BARS
                          ...data.commitments.entries.toList().asMap().entries.map((entry) {
                            final index = entry.key;
                            final category = entry.value.key;
                            final amount = entry.value.value;
                            final percentage = totalIncome == 0 ? 0.0 : amount / totalIncome;

                            return Column(
                              children: [
                                _buildCategoryBar(
                                  category,
                                  "RM $amount",
                                  percentage,
                                  palette[index % palette.length],
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
          width: 12, height: 12,
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
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: valueColor)),
      ],
    );
  }

  Widget _buildCategoryBar(String label, String amount, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
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
    Paint paint = Paint()..style = PaintingStyle.fill..strokeCap = StrokeCap.round;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    double startAngle = -pi / 2;

    for (var segment in segments) {
      final sweepAngle = 2 * pi * segment.percentage;
      paint.color = segment.color;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, true, paint);
      
      final borderPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, true, borderPaint);
      
      startAngle += sweepAngle;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}