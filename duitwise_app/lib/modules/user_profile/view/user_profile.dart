import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:duitwise_app/services/firebase_auth/auth_controller.dart';
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

                    const SizedBox(height: 30),

                    RoundedCard(
                      borderRadius: 16,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .signOut();
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
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

const _dialogTitleStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);

const _dialogBodyStyle = TextStyle(fontSize: 15, color: Colors.black87);

const _dialogInset = EdgeInsets.symmetric(horizontal: 24);

Future<(String, int)?> _showAddCommitmentDialog(BuildContext context) {
  final labelController = TextEditingController();
  final amountController = TextEditingController();

  return showDialog<(String, int)>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: _dialogInset,
        child: RoundedCard(
          borderRadius: 18,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Add Commitment", style: _dialogTitleStyle),

                const SizedBox(height: 18),

                TextField(
                  controller: labelController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: "Commitment name",
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Allocated amount",
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final label = labelController.text.trim();
                        final amount = int.tryParse(
                          amountController.text.trim(),
                        );

                        if (label.isEmpty || amount == null || amount <= 0) {
                          return;
                        }

                        Navigator.of(context).pop((label, amount));
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: _dialogInset,
        child: RoundedCard(
          borderRadius: 18,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Edit Commitment", style: _dialogTitleStyle),

                const SizedBox(height: 10),

                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final value = int.tryParse(controller.text.trim());
                        if (value == null || value <= 0) return;
                        Navigator.of(context).pop(value);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<bool?> _confirmDelete(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: _dialogInset,
        child: RoundedCard(
          borderRadius: 18,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Delete commitment", style: _dialogTitleStyle),

                const SizedBox(height: 12),

                const Text(
                  "Are you sure you want to delete this commitment?\n"
                  "This action cannot be undone.",
                  style: _dialogBodyStyle,
                ),

                const SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
