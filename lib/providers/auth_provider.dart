import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickshop_final/models/user.dart';
import 'package:quickshop_final/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final firebaseUser = await AuthService.login(email, password);
      _user = AppUser(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'User',
        email: firebaseUser.email!,
        joinedAt: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final firebaseUser = await AuthService.signup(name, email, password);
      _user = AppUser(
        id: firebaseUser.uid,
        name: name,
        email: email,
        joinedAt: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        _user = user;
        notifyListeners();
      }
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}