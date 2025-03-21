import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;
  bool get isStudent => _user?.isStudent ?? false;
  bool get isTeacher => _user?.isTeacher ?? false;

  // Constructor that checks for existing login
  AuthProvider() {
    _checkCurrentAuth();
  }

  // Automatically check if user is already logged in
  Future<void> _checkCurrentAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _apiService.isLoggedIn();

      if (isLoggedIn) {
        _user = await _apiService.getCurrentUser();
      }
    } catch (e) {
      print('Error checking authentication: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);

      if (result['success']) {
        _user = result['user'];
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi nanti.';
      print('Login error in provider: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.logout();

      if (result) {
        _user = null;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Gagal logout. Coba lagi.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi nanti.';
      print('Logout error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_user == null) {
      _errorMessage = 'Anda harus login terlebih dahulu.';
      notifyListeners();
      return false;
    }

    final result = _user!.isStudent
        ? await _apiService.updateStudentProfile(_user!.id, data)
        : await _apiService.updateTeacherProfile(_user!.id, data);

    if (result['success']) {
      _user = _user!.isStudent ? result['student'] : result['teacher'];
      notifyListeners();
      return true;
    }

    _errorMessage = result['message'];
    notifyListeners();
    return false;
  }

  // Upload profile photo
  Future<bool> uploadProfilePhoto(File photo) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_user == null) {
      _errorMessage = 'Anda harus login terlebih dahulu.';
      notifyListeners();
      return false;
    }

    final result = _user!.isStudent
        ? await _apiService.uploadStudentProfilePhoto(_user!.id, photo)
        : await _apiService.uploadTeacherProfilePhoto(_user!.id, photo);

    if (result['success']) {
      // Update the user's profile photo URL
      _user = _user!.copyWith(profilePhotoUrl: result['profile_photo_url']);
      notifyListeners();
      return true;
    }

    _errorMessage = result['message'];
    notifyListeners();
    return false;
  }

  // Reset error message
  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Update user info
  void updateUserInfo(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
