import 'package:duitwise_app/core/widgets/add_transaction_popup.dart';
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
  void _showAddTransactionPopup({
    required String uid,
    required List<String> categories,
  }) {
    showDialog(
      context: context,
      builder: (context) =>
          AddTransactionPopup(uid: uid, categories: categories),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userStreamProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
      data: (user) {
        final uid = user?.uid;
        if (uid == null) {
          return const Scaffold(body: Center(child: Text("No user found")));
        }

        final financialAsync = ref.watch(financialStreamProvider(uid));

        return Scaffold(
          backgroundColor: const Color(0xFFA0E5C7),
          body: SafeArea(
            child: financialAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (financial) {
                final commitments = financial.commitments; // Map<String, int>
                // ignore: unused_local_variable
                final categories = commitments.keys.toList();

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
                      const SizedBox(height: 15),

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

                              ...commitments.entries.map((entry) {
                                final name = entry.key;
                                final allocated = entry.value.toDouble();

                                // REAL USED VALUE from RTDB: financial/used/<name>
                                final used =
                                    ((financial.used[name] ?? 0) as num)
                                        .toDouble();

                                final percent = allocated == 0
                                    ? 0
                                    : ((used / allocated) * 100)
                                          .clamp(0, 100)
                                          .toInt();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "RM${used.toStringAsFixed(2)} of RM${allocated.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: LinearProgressIndicator(
                                                value: allocated == 0
                                                    ? 0
                                                    : (used / allocated).clamp(
                                                        0,
                                                        1,
                                                      ),
                                                minHeight: 10,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xFF7DD3AE)),
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
          floatingActionButton: financialAsync.maybeWhen(
            data: (financial) {
              final categories = financial.commitments.keys.toList();

              return FloatingActionButton(
                onPressed: () =>
                    _showAddTransactionPopup(uid: uid, categories: categories),
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: RoundedCard(
                  borderRadius: 18,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: const Icon(Icons.add, color: Colors.black, size: 32),
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
