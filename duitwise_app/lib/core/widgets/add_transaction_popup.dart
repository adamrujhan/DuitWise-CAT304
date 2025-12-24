import 'package:duitwise_app/core/widgets/custom_text_field.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/transaction_provider.dart';
import 'package:duitwise_app/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    selectedCategory = widget.categories.isNotEmpty
        ? widget.categories.first
        : "";
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
          createdAt: DateTime.now().millisecondsSinceEpoch
              .toInt(), // use seconds instead of millisecond
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to add transaction: $e")));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
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
                child: CustomTextField(
                  controller: amountController,
                  hint: "0",
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
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
                        onTap: () =>
                            setState(() => selectedCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.grey[400]
                                : Colors.grey[200],
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
              CustomTextField(
                controller: notesController,
                hint: "e.g. Lunch with Wan",
                inputAction: TextInputAction.done,
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
