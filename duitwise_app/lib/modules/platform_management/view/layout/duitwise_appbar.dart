import 'package:flutter/material.dart';

class DuitWiseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const DuitWiseAppBar({super.key, this.title = "DuitWise"});

  @override
  Size get preferredSize => const Size.fromHeight(80); 
  // Tune the height depending on your design.

  @override
  Widget build(BuildContext context) {
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
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://picsum.photos/200"),
            ),
          ],
        ),
      ),
    );
  }
}
