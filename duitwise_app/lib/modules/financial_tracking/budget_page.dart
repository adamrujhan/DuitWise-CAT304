import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetPage());
}

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7), // Mint green

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Name + Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "DuitWise",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "https://picsum.photos/200", // Placeholder avatar
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Welcome Card to Budget Page
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Welcome to Budget Tracking !",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Monthly Income with nested card
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Please enter your monthly income.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RoundedCard(
                        //backgroundColor: Colors.grey[100],
                        //borderRadius: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            //controller: _incomeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: 'RM ',
                              hintText: '1000',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 120), // Scroll spacing above navbar
            ],
          ),
        ),
      ),
    );
  }
}
