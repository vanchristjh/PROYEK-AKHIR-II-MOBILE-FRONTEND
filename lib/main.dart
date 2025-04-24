import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/announcements_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/my_classes_screen.dart';
import 'screens/teaching_materials_screen.dart';
import 'screens/announcement_detail_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/attendance_provider.dart';
import 'providers/profile_provider.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'SMA N 1 Girsang Sipangan Bolon',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => LoginScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/schedule': (context) => const ScheduleScreen(),
              '/attendance': (context) => const AttendanceScreen(),
              '/announcements': (context) => const AnnouncementsScreen(),
              '/settings': (context) => const SettingsScreen(),
              // Teacher specific routes
              '/my-classes': (context) => const MyClassesScreen(),
              '/teaching-materials': (context) => const TeachingMaterialsScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/announcement-detail') {
                final int announcementId = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (context) => AnnouncementDetailScreen(announcementId: announcementId),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
