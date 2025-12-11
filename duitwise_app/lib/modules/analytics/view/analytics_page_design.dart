import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:flutter/material.dart';

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

              // Header Card
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Spending Analytics",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.bar_chart_rounded,
                        size: 32,
                        color: Colors.grey[800],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Overview Section (Replaced Input with Display Data)
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Monthly Overview",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nested Card for Key Stats (Mimics your text field style)
                      RoundedCard(
                        // If your RoundedCard supports color params, you can add them here
                        // otherwise it defaults to white/theme default
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Category Breakdown Section
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Top Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // List of progress bars
                      _buildCategoryBar(
                        "Food & Dining",
                        "RM 1,200",
                        0.7,
                        Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryBar(
                        "Transportation",
                        "RM 450",
                        0.4,
                        Colors.purple,
                      ),
                      const SizedBox(height: 16),
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

  // Helper widget for the Overview stats
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

  // Helper widget for Category Progress Bars
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
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage, // 0.0 to 1.0
          backgroundColor: Colors.grey[200],
          color: color,
          borderRadius: BorderRadius.circular(8),
          minHeight: 10,
        ),
      ],
    );
  }
}
