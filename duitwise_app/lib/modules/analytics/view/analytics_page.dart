import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(home: AnalyticsPage()));
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7), // Mint green

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),

              // ------------------------------------------------
              // 1. TOP BOX: Welcome to Spending Analytics
              // ------------------------------------------------
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

              // ------------------------------------------------
              // 2. SECOND BOX: Pie Chart
              // ------------------------------------------------
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Distribution",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: CustomPaint(
                            painter: PieChartPainter(
                              segments: [
                                PieSegment(
                                  color: Colors.orange,
                                  percentage: 0.4,
                                ), // Food
                                PieSegment(
                                  color: Colors.purple,
                                  percentage: 0.35,
                                ), // Transport
                                PieSegment(
                                  color: Colors.teal,
                                  percentage: 0.25,
                                ), // Utilities
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLegendItem(Colors.orange, "Food"),
                          _buildLegendItem(Colors.purple, "Transport"),
                          _buildLegendItem(Colors.teal, "Utilities"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ------------------------------------------------
              // 3. LAST BOX: Spending Analytics (Details)
              // ------------------------------------------------
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Spending Analytics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nested Card for Key Stats
                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildStatRow(
                                "Total Budget",
                                "RM 5,000",
                                Colors.blue,
                              ),
                              const Divider(height: 24),
                              _buildStatRow(
                                "Total Spent",
                                "RM 3,250",
                                Colors.red,
                              ),
                              const Divider(height: 24),
                              _buildStatRow(
                                "Remaining",
                                "RM 1,750",
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
                      _buildCategoryBar(
                        "Food & Dining",
                        "RM 1,200",
                        0.7,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildCategoryBar(
                        "Transportation",
                        "RM 450",
                        0.4,
                        Colors.purple,
                      ),
                      const SizedBox(height: 12),
                      _buildCategoryBar(
                        "Utilities",
                        "RM 300",
                        0.25,
                        Colors.teal,
                      ),
                    ],
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

  Widget _buildLegendItem(Color color, String label) {
    return Row(
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
    String amount,
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
              amount,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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
}

// ------------------------------------------------------
// Custom Painter for Pie Chart (No external package needed)
// ------------------------------------------------------

class PieSegment {
  final Color color;
  final double percentage; // 0.0 to 1.0

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

    double startAngle = -pi / 2; // Start from top

    for (var segment in segments) {
      final sweepAngle = 2 * pi * segment.percentage;
      paint.color = segment.color;

      // Draw slice
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true, // useCenter = true for pie slices
        paint,
      );

      // Add a thin white border between slices
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
