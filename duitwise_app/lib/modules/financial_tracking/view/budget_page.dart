import 'package:duitwise_app/core/widgets/recent_activity.dart';
import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:duitwise_app/modules/financial_tracking/providers/financial_provider.dart';
import 'package:duitwise_app/modules/user_profile/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({super.key});

  @override
  ConsumerState<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userStreamProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text("Error: $e"))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text("No user found")));
        }

        final uid = user.uid;
        final financialAsync = ref.watch(financialStreamProvider(uid));

        return financialAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, st) => Scaffold(body: Center(child: Text("Error: $e"))),
          data: (financial) {
            final income = financial.income;
            final commitments = financial.commitments;
            final usedMap = financial.used;

            // Total used across all categories
            final totalExpense = usedMap.values.fold<double>(
              0,
              (sum, v) => sum + v,
            );

            return Scaffold(
              backgroundColor: const Color(0xFFA0E5C7),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// Greeting Card
                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Good Day, ${user.name}!",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// Income + Expense
                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Balance",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),

                              Text(
                                "RM$income",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Text(
                                "Expense",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),

                              Text(
                                "RM${totalExpense.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// Monthly Budget Tracking (show only 3)
                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Monthly Budget Tracking",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.push("/budget/mybudget");
                                    },
                                    child: Text(
                                      "See all",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              ...commitments.entries.take(3).map((entry) {
                                final name = entry.key; // e.g. "Food"
                                final allocated = entry.value.toDouble();
                                final used = usedMap[name] ?? 0.0;

                                final percent = allocated == 0
                                    ? 0
                                    : ((used / allocated) * 100)
                                          .clamp(0, 100)
                                          .toInt();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
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

                      const SizedBox(height: 15),

                      /// Recent Activity (from transactions)
                      RecentActivityCard(activityNum: 6,),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
