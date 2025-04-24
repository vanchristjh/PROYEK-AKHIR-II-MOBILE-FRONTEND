import 'package:flutter/foundation.dart';
import '../models/attendance_model.dart';
import '../services/api_service.dart';

class AttendanceProvider with ChangeNotifier {
  List<AttendanceRecord> _attendanceRecords = [];
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAttendanceRecords() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedRecords = await _apiService.getAttendanceRecords();
      _attendanceRecords = fetchedRecords;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat data absensi. Silakan coba lagi.';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get attendance summary
  Map<String, int> getAttendanceSummary() {
    final Map<String, int> summary = {
      'hadir': 0,
      'izin': 0,
      'sakit': 0,
      'alpa': 0,
      'terlambat': 0,
    };

    for (var record in _attendanceRecords) {
      if (summary.containsKey(record.status.toLowerCase())) {
        summary[record.status.toLowerCase()] = summary[record.status.toLowerCase()]! + 1;
      }
    }

    return summary;
  }

  // Calculate attendance percentage
  double getAttendancePercentage() {
    if (_attendanceRecords.isEmpty) return 0.0;

    int present = 0;
    for (var record in _attendanceRecords) {
      if (record.status.toLowerCase() == 'hadir') {
        present++;
      }
    }

    return (present / _attendanceRecords.length) * 100;
  }
}
