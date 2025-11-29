import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? navBar;
  final FloatingActionButton? fab;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.navBar,
    this.fab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: appBar,
      body: SafeArea(child: body),
      bottomNavigationBar: navBar,
      floatingActionButton: fab,
    );
  }
}