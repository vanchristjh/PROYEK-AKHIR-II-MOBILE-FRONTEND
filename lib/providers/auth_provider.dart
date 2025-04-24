import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import 'dart:developer' as developer;

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  get isTeacher => null;

  get userData => null;

  Future<bool> checkAuthStatus() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      developer.log('Checking auth status', name: 'AuthProvider');
      
      // Get the response from API service
      final response = await _apiService.getCurrentUser();
      
      if (response['success'] == true) {
        // Extract user data and convert to User object
        final userData = response['user'];
        _user = User.fromJson(userData);
        _errorMessage = null;
        
        developer.log('User authenticated: ${_user!.name}', name: 'AuthProvider');
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _user = null;
        _errorMessage = response['message'];
        
        developer.log('Auth check failed: $_errorMessage', name: 'AuthProvider');
        
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      developer.log('Error checking auth status: $e', name: 'AuthProvider', error: e);
      _isLoading = false;
      _user = null;
      _errorMessage = 'Authentication check failed';
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      developer.log('Attempting login', name: 'AuthProvider');
      final result = await _apiService.login(email, password);

      if (result['success']) {
        // Convert user data to User object
        _user = User.fromJson(result['user']);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        developer.log('Login successful', name: 'AuthProvider');
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        developer.log('Login failed: $_errorMessage', name: 'AuthProvider');
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat login. Silakan coba lagi.';
      _isLoading = false;
      notifyListeners();
      developer.log('Login error: $e', name: 'AuthProvider', error: e);
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      developer.log('Attempting logout', name: 'AuthProvider');
      await _apiService.logout();
      
      _user = null;
      _isLoading = false;
      notifyListeners();
      developer.log('Logout successful', name: 'AuthProvider');
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      developer.log('Logout error: $e', name: 'AuthProvider', error: e);
    }
  }

  // Update user profile locally
  void updateUserProfile(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
