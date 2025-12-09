import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/data/models/user_model.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
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
  final List<TextEditingController> commitments = [];

  @override
  void initState() {
    super.initState();
    commitments.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userStreamProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text("Error loading user: $e"))),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("User profile unavailable")),
          );
        }

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
                        const RoundedCard(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
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
                        _buildIncomeField(),

                        const SizedBox(height: 15),

                        // Commitments List
                        _buildCommitmentsSection(),

                        const SizedBox(height: 20),

                        // NEXT BUTTON
                        _buildNextButton(user.uid),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------
  // WIDGET BUILDERS
  // ---------------------------------------------

  Widget _buildIncomeField() {
    return RoundedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please enter your monthly income.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
    );
  }

  Widget _buildCommitmentsSection() {
    return RoundedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please enter your commitments.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),

            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: commitments.asMap().entries.map((entry) {
                final ctrl = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: ctrl,
                          decoration: InputDecoration(
                            hintText: "Enter commitment (e.g. Food, Bills)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            commitments.add(TextEditingController());
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
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(String uid) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Convert commitments into key-value map: {"home": 0, "food": 0}
          final commitmentMap = {
            for (var c
                in commitments
                    .map((t) => t.text.trim())
                    .where((t) => t.isNotEmpty))
              c: 0,
          };

          final financialData = {
            "income": int.tryParse(incomeCtrl.text.trim()) ?? 0,
            "commitments": commitmentMap,
            "hasSetupBudget": true,
          };

          await ref
              .read(financialRepositoryProvider)
              .updateFinancial(uid, financialData);

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Financial data updated!")),
          );

          context.push('/budget/allocation'); // NEW nested route navigation
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Next >",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  // ---------------------------------------------
  // CLEANUP
  // ---------------------------------------------
  @override
  void dispose() {
    incomeCtrl.dispose();
    for (var ctrl in commitments) {
      ctrl.dispose();
    }
    super.dispose();
  }
}
