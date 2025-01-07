import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  String _username = '';

  String get username => _username;

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('user_data');
      await prefs.remove('token');

      _username = '';

      debugPrint('User signed out successfully');
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
      throw Exception('Failed to sign out');
    }
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');

      if (userData != null) {
        final decodedData = json.decode(userData);
        _username = decodedData['name'] ?? '';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }
}
