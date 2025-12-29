import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (user) {
            if (user == null) {
              return const Center(child: Text("No user data"));
            }

            final financialAsync = ref.watch(financialStreamProvider(user.uid));

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    RoundedCard(
                      borderRadius: 16,
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "My Profile",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    RoundedCard(
                      borderRadius: 16,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Username",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    financialAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text(e.toString())),
                      data: (financial) {
                        final commitments = financial.commitments;

                        if (commitments.isEmpty) {
                          return const Text("No commitments recorded");
                        }

                        return RoundedCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Commitments",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      tooltip: "Add commitment",
                                      onPressed: () async {
                                        final result =
                                            await _showAddCommitmentDialog(
                                              context,
                                            );

                                        if (result != null) {
                                          final label = result.$1;
                                          final amount = result.$2;

                                          // Trigger state update
                                          ref
                                              .read(
                                                financialControllerProvider
                                                    .notifier,
                                              )
                                              .addCommitment(
                                                uid: user.uid,
                                                label: label,
                                                amount: amount,
                                              );
                                        }
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                ...commitments.keys.map((label) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "• $label",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          tooltip: "Edit amount",
                                          onPressed: () async {
                                            final newAmount =
                                                await _showEditCommitmentDialog(
                                                  context,
                                                  label: label,
                                                  currentAmount:
                                                      commitments[label]!,
                                                );

                                            if (newAmount != null) {
                                              ref
                                                  .read(
                                                    financialControllerProvider
                                                        .notifier,
                                                  )
                                                  .addCommitment(
                                                    uid: user.uid,
                                                    label: label,
                                                    amount: newAmount,
                                                  );
                                              // same function, update() will overwrite the value
                                            }
                                          },
                                        ),

                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          tooltip: "Delete commitment",
                                          color: Colors.redAccent,
                                          onPressed: () async {
                                            final confirmed =
                                                await _confirmDelete(context);

                                            if (confirmed == true) {
                                              ref
                                                  .read(
                                                    financialControllerProvider
                                                        .notifier,
                                                  )
                                                  .deleteCommitment(
                                                    uid: user.uid,
                                                    label: label,
                                                  );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<(String, int)?> _showAddCommitmentDialog(BuildContext context) {
  final labelController = TextEditingController();
  final amountController = TextEditingController();

  return showDialog<(String, int)>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add Commitment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: "Commitment name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Allocated amount"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final label = labelController.text.trim();
              final amount = int.tryParse(amountController.text.trim());

              if (label.isEmpty || amount == null || amount <= 0) {
                return;
              }

              Navigator.of(context).pop((label, amount));
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}

Future<bool?> _confirmDelete(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // force a decision
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete commitment"),
        content: const Text(
          "Are you sure you want to delete this commitment? "
          "This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}

Future<int?> _showEditCommitmentDialog(
  BuildContext context, {
  required String label,
  required int currentAmount,
}) {
  final controller = TextEditingController(text: currentAmount.toString());

  return showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Commitment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());

              if (value == null || value <= 0) return;

              Navigator.of(context).pop(value);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
