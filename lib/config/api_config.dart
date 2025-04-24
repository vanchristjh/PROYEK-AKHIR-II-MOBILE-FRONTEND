class ApiConfig {
  // Base URL for API
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // For Android emulator
  // Use 'http://localhost:8000/api' for iOS simulator
  // Use your actual server URL for production

  // API Endpoints
  static const String loginEndpoint = '/login';
  static const String logoutEndpoint = '/logout';
  static const String userEndpoint = '/user';
  static const String studentsEndpoint = '/students';
  static const String teachersEndpoint = '/teachers';
  static const String announcementsEndpoint = '/announcements';
  static const String schedulesEndpoint = '/schedules';
  static const String todayScheduleEndpoint = '/schedules/today';
  static const String attendanceEndpoint = '/attendance';

  // Demo login credentials - to be used only for development
  static const String demoTeacherEmail = 'teacher@example.com';
  static const String demoStudentEmail = 'student@example.com';
  static const String demoPassword = 'password';
}
