import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:flutter/material.dart';

class MyBudgetPage extends StatefulWidget {
  const MyBudgetPage({super.key});

  @override
  State<MyBudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<MyBudgetPage> {
  final double totalBalance = 800;
  final double expense = 200;

  final List<BudgetCategory> budgetCategories = [
    BudgetCategory(name: "Food", percentage: 25),
    BudgetCategory(name: "Groceries", percentage: 25),
    BudgetCategory(name: "Transport", percentage: 25),
    BudgetCategory(name: "Bill", percentage: 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Greeting Card
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "My Budget",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Budget Tracking Card
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Monthly Budget Tracking",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Budget Categories
                      ...budgetCategories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "${category.percentage}%",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetCategory {
  String name;
  int percentage;

  BudgetCategory({required this.name, required this.percentage});
}

class Activity {
  String name;
  String category;
  double amount;

  Activity({required this.name, required this.category, required this.amount});
}
