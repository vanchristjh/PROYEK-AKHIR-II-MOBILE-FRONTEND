import 'package:flutter/foundation.dart';
import '../models/schedule_model.dart';
import '../services/api_service.dart';

class ScheduleProvider with ChangeNotifier {
  List<Schedule> _schedules = [];
  List<Schedule> _todaySchedules = [];
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  List<Schedule> get schedules => _schedules;
  List<Schedule> get todaySchedules => _todaySchedules;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSchedules() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedSchedules = await _apiService.getSchedules();
      _schedules = fetchedSchedules;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat jadwal. Silakan coba lagi.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTodaySchedule() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedSchedules = await _apiService.getTodaySchedule();
      _todaySchedules = fetchedSchedules;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat jadwal hari ini. Silakan coba lagi.';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Group schedules by day
  Map<String, List<Schedule>> getSchedulesByDay() {
    final Map<String, List<Schedule>> groupedSchedules = {
      'monday': [],
      'tuesday': [],
      'wednesday': [],
      'thursday': [],
      'friday': [],
      'saturday': [],
      'sunday': [],
    };

    for (var schedule in _schedules) {
      if (groupedSchedules.containsKey(schedule.dayOfWeek.toLowerCase())) {
        groupedSchedules[schedule.dayOfWeek.toLowerCase()]!.add(schedule);
      }
    }

    // Sort each day's schedules by start time
    groupedSchedules.forEach((day, schedules) {
      schedules.sort((a, b) => a.startTime.compareTo(b.startTime));
    });

    return groupedSchedules;
  }
}
