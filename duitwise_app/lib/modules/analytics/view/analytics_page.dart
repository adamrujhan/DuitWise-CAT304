import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF70D28C), // Light green color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: showingSections(),
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Detailed Spending',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  buildDetailItem('Rent', 300.00),
                  buildDetailItem('Car Payment', 150.00),
                  buildDetailItem('Groceries', 65.73),
                  buildDetailItem('Utilities', 35.42),
                  buildDetailItem('Fun Money', 34.00),
                  buildDetailItem('Date Night', 25.78),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: Colors.redAccent,
        value: 300.00,
        title: 'Rent',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.orangeAccent,
        value: 150.00,
        title: 'Car Payment',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 65.73,
        title: 'Groceries',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.blueAccent,
        value: 35.42,
        title: 'Utilities',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: 34.00,
        title: 'Fun Money',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.pinkAccent,
        value: 25.78,
        title: 'Date Night',
        radius: 50,
      ),
    ];
  }

  Widget buildDetailItem(String title, double amount) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      trailing: Text(
        '\$${amount.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
