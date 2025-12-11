import 'package:shared_preferences/shared_preferences.dart';

class BudgetSetupService {
  static const String _key = "budget_setup_complete";

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> setCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}