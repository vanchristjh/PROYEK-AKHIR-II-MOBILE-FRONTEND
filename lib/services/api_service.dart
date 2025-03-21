import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl =
      'http://10.0.2.2:8000/api'; // Android emulator localhost
  // Use 'http://localhost:8000/api' for iOS simulator or web
  // Use your actual server IP for physical devices

  ApiService() {
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['Content-Type'] = 'application/json';
    _initializeToken(); // Initialize token from storage on start
  }

  // Initialize token from storage if available
  Future<void> _initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // Set the auth token for subsequent requests
  Future<void> setAuthToken(String token) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';

    // Save token to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remove the auth token (for logout)
  Future<void> removeAuthToken() async {
    _dio.options.headers.remove('Authorization');

    // Remove token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Check if user is already logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) return false;

    // Set the token for subsequent requests
    _dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      // Verify the token by making a request to get user info
      final response = await _dio.get('$_baseUrl/auth-test');
      return response.statusCode == 200;
    } catch (e) {
      print('Auth check error: $e');
      // Token is invalid or expired
      await removeAuthToken();
      return false;
    }
  }

  // Login and get auth token
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {
          'email': email,
          'password': password,
          'device_name': 'Flutter Mobile App',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];

        // Set token for subsequent requests
        await setAuthToken(token);

        return {
          'success': true,
          'user': User.fromJson(data['user']),
          'message': data['message'],
        };
      }

      return {
        'success': false,
        'message': 'Login gagal. Coba lagi.',
      };
    } on DioException catch (e) {
      print('Login error: $e');
      print('Response data: ${e.response?.data}');

      if (e.response?.statusCode == 422) {
        // Validation error
        final messages = e.response?.data['errors'] ??
            {
              'email': ['Email atau password salah.']
            };
        final firstError =
            messages.values.first[0] ?? 'Email atau password salah.';

        return {
          'success': false,
          'message': firstError,
        };
      }

      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }

  // Logout
  Future<bool> logout() async {
    try {
      final response = await _dio.post('$_baseUrl/logout');

      if (response.statusCode == 200) {
        await removeAuthToken();
        return true;
      }

      return false;
    } catch (e) {
      print('Logout error: $e');
      // Still remove token on error
      await removeAuthToken();
      return false;
    }
  }

  // Get current user info
  Future<User?> getCurrentUser() async {
    try {
      final response = await _dio.get('$_baseUrl/user');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  // Get student data
  Future<Map<String, dynamic>> getStudentData() async {
    try {
      final response = await _dio.get('$_baseUrl/students');

      if (response.statusCode == 200) {
        final data = response.data;

        // Parse students list
        final students = (data['students'] as List)
            .map((json) => User.fromJson(json))
            .toList();

        return {
          'success': true,
          'students': students,
          'count': data['count'],
        };
      }

      return {
        'success': false,
        'message': 'Gagal mengambil data siswa.',
      };
    } catch (e) {
      print('Get student data error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }

  // Get teacher data
  Future<Map<String, dynamic>> getTeacherData() async {
    try {
      final response = await _dio.get('$_baseUrl/teachers');

      if (response.statusCode == 200) {
        final data = response.data;

        // Parse teachers list
        final teachers = (data['teachers'] as List)
            .map((json) => User.fromJson(json))
            .toList();

        return {
          'success': true,
          'teachers': teachers,
          'count': data['count'],
        };
      }

      return {
        'success': false,
        'message': 'Gagal mengambil data guru.',
      };
    } catch (e) {
      print('Get teacher data error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }

  // Update student profile
  Future<Map<String, dynamic>> updateStudentProfile(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/students/$id',
        data: data,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'student': User.fromJson(response.data['student']),
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': 'Gagal memperbarui profil.',
      };
    } catch (e) {
      print('Update student profile error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }

  // Update teacher profile
  Future<Map<String, dynamic>> updateTeacherProfile(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/teachers/$id',
        data: data,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'teacher': User.fromJson(response.data['teacher']),
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': 'Gagal memperbarui profil.',
      };
    } catch (e) {
      print('Update teacher profile error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }

  // Upload student profile photo
  Future<Map<String, dynamic>> uploadStudentProfilePhoto(
      int id, File photo) async {
    try {
      final formData = FormData.fromMap({
        'id': id,
        'profile_photo': await MultipartFile.fromFile(
          photo.path,
          filename: 'profile_photo.jpg',
        ),
      });

      final response = await _dio.post(
        '$_baseUrl/students/profile-photo',
        data: formData,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'profile_photo_url': response.data['profile_photo_url'],
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': 'Gagal mengunggah foto profil.',
      };
    } catch (e) {
      print('Upload student photo error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }

  // Upload teacher profile photo
  Future<Map<String, dynamic>> uploadTeacherProfilePhoto(
      int id, File photo) async {
    try {
      final formData = FormData.fromMap({
        'id': id,
        'profile_photo': await MultipartFile.fromFile(
          photo.path,
          filename: 'profile_photo.jpg',
        ),
      });

      final response = await _dio.post(
        '$_baseUrl/teachers/profile-photo',
        data: formData,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'profile_photo_url': response.data['profile_photo_url'],
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': 'Gagal mengunggah foto profil.',
      };
    } catch (e) {
      print('Upload teacher photo error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Coba lagi nanti.',
      };
    }
  }
}
