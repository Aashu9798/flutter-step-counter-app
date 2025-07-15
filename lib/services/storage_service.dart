import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveStepData(String date, int steps) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'steps': steps,
      'lastUpdated': DateTime.now().toUtc().toIso8601String(),
    };
    await prefs.setString(date, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getStepData(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(date);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  Future<void> saveInitialStepCount(String date, int steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("initial_$date", steps);
  }

  Future<int?> getInitialStepCount(String date) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("initial_$date");
  }

  Future<String?> getLastUpdated(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(date);
    if (data != null) {
      final decoded = jsonDecode(data);
      return decoded['lastUpdated'];
    }
    return null;
  }
}
