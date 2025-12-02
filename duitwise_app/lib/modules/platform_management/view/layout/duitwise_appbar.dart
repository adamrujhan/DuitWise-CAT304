import 'package:duitwise_app/modules/platform_management/providers/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DuitWiseAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const DuitWiseAppBar({super.key, this.title = "DuitWise"});

  @override
  Size get preferredSize => const Size.fromHeight(80);
  // Tune the height depending on your design.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: const Color(0xFFA0E5C7), // match page background if needed
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(bottomNavProvider.notifier).state = 3;
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
