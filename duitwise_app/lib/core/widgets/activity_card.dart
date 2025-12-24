import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/transaction_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityCard extends ConsumerWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Error: $e"),
      data: (user) {
        if (user == null) {
          return const Text("No user found");
        }

        final txAsync = ref.watch(transactionsStreamProvider(user.uid));

        return RoundedCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text(
                      "Error: $e",
                      style: const TextStyle(color: Colors.red),
                    ),
                    data: (txs) {
                      if (txs.isEmpty) {
                        return Text(
                          "No transactions yet.",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        );
                      }
              
                      return Column(
                        children: txs.map((t) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.category,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      t.notes,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "-RM ${t.amount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
