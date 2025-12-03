import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:flutter/material.dart';

class BudgetAllocationPage extends StatefulWidget {
  const BudgetAllocationPage({super.key});

  @override
  State<BudgetAllocationPage> createState() => _BudgetAllocationPageState();
}

class _BudgetAllocationPageState extends State<BudgetAllocationPage> {
  final TextEditingController incomeCtrl = TextEditingController();
  List<CommitmentItem> commitments = [];

  @override
  void initState() {
    super.initState();
    incomeCtrl.text = "1000";
    commitments = [
      CommitmentItem(name: "Food", controller: TextEditingController()),
      CommitmentItem(name: "Groceries", controller: TextEditingController()),
      CommitmentItem(name: "Transport", controller: TextEditingController()),
      CommitmentItem(name: "Bill", controller: TextEditingController()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      
      body: SafeArea(
        child: Column(
          children: [
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Welcome Card
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          "Welcome to Budget Tracking !",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Monthly Income Display
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Your monthly income is RM${incomeCtrl.text}.",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Commitments Card
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Enter budget for each commitment.",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Commitment Items
                            ...commitments.map((commitment) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      commitment.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: commitment.controller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "RM",
                                        filled: true,
                                        fillColor: Colors.grey[300],
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                            const SizedBox(height: 10),

                            // Next Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: Colors.grey[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Next >",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    incomeCtrl.dispose();
    for (var commitment in commitments) {
      commitment.controller.dispose();
    }
    super.dispose();
  }
}

class CommitmentItem {
  String name;
  TextEditingController controller;

  CommitmentItem({required this.name, required this.controller});
}