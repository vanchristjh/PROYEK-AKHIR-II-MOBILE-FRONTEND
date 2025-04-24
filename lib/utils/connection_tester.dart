import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ConnectionTester {
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/test'));
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
  
  static Future<Map<String, dynamic>> runDiagnostics() async {
    final results = <String, dynamic>{
      'baseUrl': ApiConfig.baseUrl,
      'tests': <String, bool>{}
    };
    
    // Test basic connectivity
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/test'));
      results['tests']['basicConnectivity'] = response.statusCode == 200;
      results['testResponse'] = response.body;
    } catch (e) {
      results['tests']['basicConnectivity'] = false;
      results['connectivityError'] = e.toString();
    }
    
    // Test login endpoint exists
    try {
      // Just check if the endpoint exists, not actually logging in
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        body: {'email': 'test@example.com', 'password': 'test'}
      );
      // Status 422 means validation error, which is fine - the endpoint exists
      results['tests']['loginEndpoint'] = 
          response.statusCode == 200 || response.statusCode == 422;
    } catch (e) {
      results['tests']['loginEndpoint'] = false;
      results['loginError'] = e.toString();
    }
    
    return results;
  }
}
