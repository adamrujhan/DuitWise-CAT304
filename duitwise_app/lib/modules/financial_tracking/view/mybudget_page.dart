import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBudgetPage extends ConsumerStatefulWidget {
  const MyBudgetPage({super.key});

  @override
  ConsumerState<MyBudgetPage> createState() => _MyBudgetPageState();
}

class _MyBudgetPageState extends ConsumerState<MyBudgetPage> {

  /// Dynamic commitment list loaded from Firebase
  List<CommitmentItem> commitments = [];

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userStreamProvider).value;
    final uid = user?.uid;

    /// Watch user's financial data (income + commitments)
    final financialAsync = ref.watch(financialStreamProvider(uid));

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: financialAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
          data: (financial) {
            final commitments = financial.commitments; // Map<String, int>

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const RoundedCard(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "My Budget",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  RoundedCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Monthly Budget Tracking",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// ---- DYNAMIC LIST FROM FIREBASE ----
                          ...commitments.entries.map((entry) {
                            final name = entry.key; // example: food
                            final allocated = entry.value; // example: 300

                            /// 🔥 Placeholder usage value (until you have expense tracking)
                            const used =
                                80; // <-- UPDATE WHEN YOU HAVE REAL EXPENSE DATA

                            final percent = allocated == 0
                                ? 0
                                : ((used / allocated) * 100)
                                      .clamp(0, 100)
                                      .toInt();

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Category Name
                                  Text(
                                    name[0].toUpperCase() + name.substring(1),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  /// "RM80 of RM300"
                                  Text(
                                    "RM$used of RM$allocated",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  /// Progress Bar + Percent
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: allocated == 0
                                                ? 0
                                                : used / allocated,
                                            minHeight: 10,
                                            backgroundColor: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      Text(
                                        "$percent%",
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
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CommitmentItem {
  String name;
  TextEditingController amount;
  CommitmentItem({required this.name, required this.amount});
}