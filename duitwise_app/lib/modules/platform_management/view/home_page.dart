import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7), // Mint green
      // Bottom Navigation
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),

          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, size: 30, color: Color(0xFF4E7D61)),
            Icon(Icons.book, size: 30, color: Colors.grey),
            Icon(Icons.grid_view, size: 30, color: Colors.grey),
            Icon(Icons.person, size: 30, color: Colors.grey),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Name + Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "DuitWise",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "https://picsum.photos/200", // Placeholder avatar
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Welcome Card
              _RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Welcome, Amrul",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dashboard Card (with Chart)
              _RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 220,
                        child: LineChart(_sampleChartData()),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Weekly spending card
              _RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "This week spending",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
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

// ---------------------------------------------------------------
// Rounded Card Widget (Reusable)
// ---------------------------------------------------------------
class _RoundedCard extends StatelessWidget {
  final Widget child;

  const _RoundedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

// linechart
LineChartData _sampleChartData() {
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
        spots: const [
          FlSpot(0, 35),
          FlSpot(1, 36),
          FlSpot(2, 38),
          FlSpot(3, 41),
          FlSpot(4, 39),
          FlSpot(5, 42),
          FlSpot(6, 48),
        ],
      ),
    ],
  );
}
