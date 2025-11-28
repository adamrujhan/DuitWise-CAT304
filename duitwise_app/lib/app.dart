import 'package:flutter/material.dart';

// You can create these later
// import 'core/theme/app_theme.dart';
// import 'core/routing/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuitWise',

      // TEMP THEMES — replace with your AppTheme later
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      // TEMP ROUTE — replace with your Routes class later
      initialRoute: '/',
      routes: {
        '/': (_) => const Placeholder(), // splash or onboarding later
      },

      debugShowCheckedModeBanner: false,
    );
  }
}
