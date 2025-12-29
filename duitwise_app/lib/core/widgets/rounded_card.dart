import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const RoundedCard({super.key, required this.child, this.borderRadius = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
