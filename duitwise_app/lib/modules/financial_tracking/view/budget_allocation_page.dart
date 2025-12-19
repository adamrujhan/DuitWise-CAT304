import 'package:duitwise_app/core/routing/app_keys.dart';
import 'package:duitwise_app/core/widgets/custom_text_field.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetAllocationPage extends ConsumerStatefulWidget {
  const BudgetAllocationPage({super.key});

  @override
  ConsumerState<BudgetAllocationPage> createState() =>
      _BudgetAllocationPageState();
}

class _BudgetAllocationPageState extends ConsumerState<BudgetAllocationPage> {
  late final ProviderSubscription _financialListener;
  final TextEditingController incomeCtrl = TextEditingController();
  bool _initialized = false;

  /// Dynamic commitment list loaded from Firebase
  List<CommitmentItem> commitments = [];

  @override
  void initState() {
    super.initState();

    _financialListener = ref.listenManual<AsyncValue<void>>(
      financialControllerProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            messengerKey.currentState?.showSnackBar(
              const SnackBar(content: Text("Financial data updated!")),
            );
            context.go('/budget');
          },
          error: (e, _) {
            messengerKey.currentState?.showSnackBar(
              SnackBar(content: Text("Update failed: $e")),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userStreamProvider).value;
    final uid = user?.uid;

    /// Live financial data from Firebase
    final financialAsync = ref.watch(financialStreamProvider(uid));

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: financialAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
          data: (financial) {
            if (!_initialized) {
              incomeCtrl.text = financial.income.toString();

              commitments = financial.commitments.entries.map((entry) {
                return CommitmentItem(
                  name: entry.key,
                  controller: TextEditingController(
                    text: entry.value.toString(),
                  ),
                );
              }).toList();

              _initialized = true;
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        const RoundedCard(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Welcome to Budget Tracking!",
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
                            child: Text(
                              "Your monthly income is RM${financial.income}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// Commitment input
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

                                /// DYNAMIC commitment fields from Firebase
                                ...commitments.map((c) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.name[0].toUpperCase() +
                                              c.name.substring(1),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        CustomTextField(
                                          hint: "RM",
                                          controller: c.controller,
                                          keyboardType: TextInputType.number,
                                          inputAction: TextInputAction.done,
                                        ),
                                      ],
                                    ),
                                  );
                                }),

                                const SizedBox(height: 10),

                                /// Save button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final newData = {
                                        "income":
                                            int.tryParse(incomeCtrl.text) ?? 0,
                                        "commitments": {
                                          for (var c in commitments)
                                            c.name:
                                                int.tryParse(
                                                  c.controller.text,
                                                ) ??
                                                0,
                                        },
                                        "hasSetupBudget": true,
                                      };

                                      await ref
                                          .read(
                                            financialControllerProvider
                                                .notifier,
                                          )
                                          .updateFinancial(uid, newData);
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
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _financialListener.close();
    incomeCtrl.dispose();
    for (var c in commitments) {
      c.controller.dispose();
    }
    super.dispose();
  }
}

class CommitmentItem {
  String name;
  TextEditingController controller;
  CommitmentItem({required this.name, required this.controller});
}
