import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import '../utils/debug_tools.dart';
import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api', // Use this for Android emulator
      // baseUrl: 'http://127.0.0.1:8000/api', // Use this for iOS simulator or web
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    
    // Add debug interceptor
    _dio.interceptors.add(DebugInterceptor());
  }
  
  // Method untuk login
  Future<Map<String, dynamic>> login(String email, String password) async {
    developer.log('Login attempt', name: 'ApiService', error: null);
    try {
      developer.log('API URL: $baseUrl/login', name: 'ApiService');
      
      // Gunakan Dio untuk konsistensi dan fitur yang lebih baik
      final response = await _dio.post('/login',
        data: {
          'email': email,
          'password': password,
          'device_name': 'flutter_app'
        },
      );
      
      developer.log('Login response status: ${response.statusCode}', name: 'ApiService');
      developer.log('Login response data: ${response.data}', name: 'ApiService');
      
      // Periksa berbagai format response yang mungkin
      Map<String, dynamic> data;
      if (response.data is Map<String, dynamic>) {
        data = response.data;
      } else if (response.data is String) {
        data = jsonDecode(response.data);
      } else {
        throw Exception('Unexpected response format: ${response.data.runtimeType}');
      }
      
      // Handle berbagai format success indicator
      bool isSuccess = false;
      if (data.containsKey('success')) {
        isSuccess = data['success'] == true;
      } else if (response.statusCode == 200) {
        isSuccess = true;
      }
      
      // Handle berbagai format token
      String? token;
      if (data.containsKey('token')) {
        token = data['token'];
      } else if (data.containsKey('access_token')) {
        token = data['access_token'];
      } else if (data.containsKey('data') && data['data'] is Map && data['data'].containsKey('token')) {
        token = data['data']['token'];
      }
      
      if (isSuccess && token != null) {
        // Simpan token untuk penggunaan selanjutnya
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        developer.log('Token saved successfully', name: 'ApiService');
        
        // Handle berbagai format user data
        Map<String, dynamic>? userData;
        if (data.containsKey('user')) {
          userData = data['user'];
        } else if (data.containsKey('data') && data['data'] is Map && data['data'].containsKey('user')) {
          userData = data['data']['user'];
        }
        
        return {
          'success': true,
          'user': userData ?? {'name': 'User', 'email': email}, // Fallback jika user data tidak ada
          'message': data['message'] ?? 'Login berhasil'
        };
      } else {
        developer.log('Login failed: ${data['message'] ?? "Unknown error"}', name: 'ApiService');
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal. Pastikan email dan password benar.'
        };
      }
    } catch (e, stackTrace) {
      developer.log('Login error: $e', name: 'ApiService', error: e);
      developer.log('Stack trace: $stackTrace', name: 'ApiService');
      
      // Menampilkan pesan error yang lebih spesifik
      String errorMessage = 'Terjadi kesalahan saat login.';
      
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout) {
          errorMessage = 'Koneksi timeout. Periksa koneksi internet Anda.';
        } else if (e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Server lambat merespon. Coba lagi nanti.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
        } else if (e.response != null) {
          if (e.response!.statusCode == 401) {
            errorMessage = 'Email atau password salah.';
          } else if (e.response!.statusCode == 422) {
            errorMessage = 'Data yang dimasukkan tidak valid.';
          } else if (e.response!.statusCode == 500) {
            errorMessage = 'Terjadi kesalahan pada server. Coba lagi nanti.';
          }
          
          // Tampilkan data response jika ada
          if (e.response!.data != null) {
            developer.log('Response data on error: ${e.response!.data}', name: 'ApiService');
          }
        }
      } else if (e is FormatException) {
        errorMessage = 'Format data dari server tidak sesuai. Coba lagi nanti.';
      }
      
      return {
        'success': false,
        'message': errorMessage
      };
    }
  }
  
  // Simpan token ke shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  // Ambil token dari shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  // Hapus token (logout)
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Implement the logout method
  Future<Map<String, dynamic>> logout() async {
    try {
      String? token = await getToken();
      if (token == null) {
        return {'success': true, 'message': 'Already logged out'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Regardless of response, remove token from shared preferences
      await removeToken();
      
      return {
        'success': true,
        'message': 'Logout berhasil'
      };
    } catch (e) {
      developer.log('Logout error: $e', name: 'ApiService', error: e);
      // Still remove token even if there's an error
      await removeToken();
      return {
        'success': true,
        'message': 'Logout berhasil'
      };
    }
  }

  // Implement getCurrentUser method
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      String? token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer.log('Get current user response: ${response.body}', name: 'ApiService');
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to get user data',
        };
      }
    } catch (e) {
      developer.log('Get current user error: $e', name: 'ApiService', error: e);
      return {
        'success': false,
        'message': 'Error getting user data: $e',
      };
    }
  }

  getAnnouncements() {}

  getAttendanceRecords() {}

  updateProfile(int userId, Map<String, dynamic> data) {}

  uploadProfilePhoto(File photo, int userId) {}

  getSchedules() {}

  getTodaySchedule() {}
}
