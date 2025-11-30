import 'package:duitwise_app/core/widgets/rounded_card.dart';
import 'package:flutter/material.dart';

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

              const SizedBox(height: 20),

              // Monthly Income
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Please enter your monthly income.",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Weekly spending card
              RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "This week spending",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
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