import 'package:flutter/material.dart';


class RoundedCard extends StatelessWidget {
  final Widget child;

  const RoundedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}