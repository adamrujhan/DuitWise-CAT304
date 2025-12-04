import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/data/models/user_model.dart';
import 'package:duitwise_app/modules/financial_tracking/provider/budget_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetSetupPage extends ConsumerStatefulWidget {
  final UserModel user;

  const BudgetSetupPage({super.key, required this.user});

  @override
  ConsumerState<BudgetSetupPage> createState() => _BudgetSetupPageState();
}

class _BudgetSetupPageState extends ConsumerState<BudgetSetupPage> {
  final TextEditingController incomeCtrl = TextEditingController();
  List<TextEditingController> commitments = [];

  @override
  void initState() {
    super.initState();
    // Start with one commitment field by default
    commitments.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),

                    // Welcome Card
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          "Welcome to Budget Tracking!",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Monthly Income Input
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Please enter your monthly income.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: incomeCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "RM",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Commitments List
                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Please enter your commitments.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 15),

                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: commitments.asMap().entries.map((
                                entry,
                              ) {
                                final ctrl = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: ctrl,
                                          decoration: InputDecoration(
                                            hintText:
                                                "Enter commitment (e.g. Food, Bills)",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            commitments.add(
                                              TextEditingController(),
                                            );
                                          });
                                        },
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[500],
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 20),

                            // NEXT BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final uid = widget.user.uid;

                                  final financialData = {
                                    "income":
                                        int.tryParse(incomeCtrl.text.trim()) ??
                                        0,
                                    "commitments": commitments
                                        .map((c) => c.text.trim())
                                        .toList(),
                                  };

                                  // Save to Firebase via Riverpod provider
                                  await ref
                                      .read(budgetServiceProvider)
                                      .updateFinancial(uid, financialData);

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Financial data updated!"),
                                    ),
                                  );

                                  // Navigate to BudgetAllocationPage
                                  context.push(
                                    '/budget-allocation',
                                    extra: widget.user,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  backgroundColor: Colors.grey[500],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Next >",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    incomeCtrl.dispose();
    for (var ctrl in commitments) {
      ctrl.dispose();
    }
    super.dispose();
  }
}
