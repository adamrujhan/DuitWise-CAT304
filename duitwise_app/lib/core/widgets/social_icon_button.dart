import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          icon,
          width: 28,
          height: 28,
        ),
      ),
    );
  }
}
