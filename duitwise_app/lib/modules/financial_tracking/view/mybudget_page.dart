import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/transaction_provider.dart';
import 'package:duitwise_app/data/models/transaction_model.dart';
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
      builder: (context) => AddTransactionPopup(uid: uid, categories: categories),
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

                              ...commitments.entries.map((entry) {
                                final name = entry.key; // e.g. "Food"
                                final allocated = entry.value.toDouble();

                                // ✅ REAL USED VALUE from RTDB: financial/used/<name>
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
                                                    : (used / allocated)
                                                        .clamp(0, 1),
                                                minHeight: 10,
                                                backgroundColor:
                                                    Colors.grey[300],
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xFF7DD3AE),
                                                ),
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
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Colors.black, size: 32),
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

// Add Transaction Popup
class AddTransactionPopup extends ConsumerStatefulWidget {
  final List<String> categories;
  final String uid;

  const AddTransactionPopup({
    super.key,
    required this.categories,
    required this.uid,
  });

  @override
  ConsumerState<AddTransactionPopup> createState() =>
      _AddTransactionPopupState();
}

class _AddTransactionPopupState extends ConsumerState<AddTransactionPopup> {
  late String selectedCategory;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedCategory =
        widget.categories.isNotEmpty ? widget.categories.first : "";
  }

  Future<void> _handleAdd() async {
    final raw = amountController.text.trim();
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.tryParse(cleaned) ?? 0.0;

    if (amount <= 0 || selectedCategory.isEmpty) return;

    final notes = notesController.text.trim().isEmpty
        ? "Transaction"
        : notesController.text.trim();

    setState(() => isSaving = true);

    try {
      final repo = ref.read(transactionRepositoryProvider);

      // 1) Save transaction history
      await repo.addTransaction(
        widget.uid,
        TransactionModel(
          id: '',
          notes: notes,
          category: selectedCategory,
          amount: amount,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      // 2) Update used amount for budget tracking
      await repo.addToUsed(
        uid: widget.uid,
        category: selectedCategory,
        amount: amount,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add transaction: $e")),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Add Transaction",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Amount",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                  hintText: "RM 0.00",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Category",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.categories.length,
                itemBuilder: (context, index) {
                  final category = widget.categories[index];
                  final isSelected = selectedCategory == category;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < widget.categories.length - 1 ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.grey[400] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Notes",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                hintText: "e.g. Lunch with Wan",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: isSaving ? null : _handleAdd,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  backgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isSaving ? "Saving..." : "Add",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
    notesController.dispose();
    amountController.dispose();
    super.dispose();
  }
}