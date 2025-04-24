import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class ProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<Map<String, dynamic>> updateProfile(int userId, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.updateProfile(userId, data);
      _isLoading = false;
      
      if (!result['success']) {
        _errorMessage = result['message'];
      }
      
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui profil. Silakan coba lagi.';
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': _errorMessage,
      };
    }
  }

  Future<Map<String, dynamic>> uploadProfilePhoto(File photo, int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.uploadProfilePhoto(photo, userId);
      _isLoading = false;
      
      if (!result['success']) {
        _errorMessage = result['message'];
      }
      
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = 'Gagal mengupload foto profil. Silakan coba lagi.';
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': _errorMessage,
      };
    }
  }
}
