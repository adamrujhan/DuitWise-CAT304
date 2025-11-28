import 'package:flutter/material.dart';
import 'core/routing/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // App name
      title: 'DuitWise',

      // Light & Dark theme (replace later with your AppTheme files)
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),

      // GoRouter configuration
      routerConfig: router,
    );
  }
}
