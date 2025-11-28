import 'package:flutter/material.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services here when needed:
  // await Firebase.initializeApp();
  // await dotenv.load();
  // ServiceLocator.init();

  runApp(const App());
}
