import 'package:flutter/foundation.dart';
import '../models/announcement_model.dart';
import '../services/api_service.dart';

class AnnouncementProvider with ChangeNotifier {
  List<Announcement> _announcements = [];
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  List<Announcement> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAnnouncements() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedAnnouncements = await _apiService.getAnnouncements();
      _announcements = fetchedAnnouncements;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat pengumuman. Silakan coba lagi.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Announcement? getAnnouncementById(int id) {
    try {
      return _announcements.firstWhere((announcement) => announcement.id == id);
    } catch (e) {
      return null;
    }
  }
}
