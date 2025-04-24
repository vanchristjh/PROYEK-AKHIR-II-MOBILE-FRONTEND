import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/profile_avatar.dart';
import 'components/teacher_home_screen.dart';
import 'components/student_home_screen.dart';

class DashboardScreen extends StatefulWidget {
  // Add optional parameter to force a specific user type
  final bool? forceTeacher;
  
  const DashboardScreen({Key? key, this.forceTeacher}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    
    // Use either forced value or actual user role
    final isTeacher = widget.forceTeacher ?? auth.isTeacher ?? false;
    
    // If no user, we should redirect to login
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Build dashboard content based on user role
    return Scaffold(
      appBar: _buildAppBar(context, user.name ?? "Pengguna", isTeacher),
      body: _buildBody(context, isTeacher),
      bottomNavigationBar: _buildBottomNavBar(context),
      drawer: _buildDrawer(context, user, isTeacher),
    );
  }

  AppBar _buildAppBar(BuildContext context, String username, bool isTeacher) {
    return AppBar(
      title: Text(
        isTeacher ? "Selamat datang, Guru $username" : "Selamat datang, Siswa $username",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Show notifications
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur notifikasi akan segera hadir'))
            );
          },
        ),
        const SizedBox(width: 10),
      ],
      elevation: 0,
      backgroundColor: Colors.indigo,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade700, Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isTeacher) {
    // Show different body content based on selected tab
    switch (_currentIndex) {
      case 0:
        return isTeacher 
            ? const TeacherHomeScreen()
            : const StudentHomeScreen();
      case 1:
        return _buildScheduleTab(context, isTeacher);
      case 2:
        return _buildAttendanceTab(context, isTeacher);
      case 3:
        return _buildProfileTab(context, isTeacher);
      default:
        return const Center(child: Text('Tab tidak tersedia'));
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Jadwal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          activeIcon: Icon(Icons.assignment),
          label: 'Absensi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, dynamic user, bool isTeacher) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade700, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatar(
                  imageUrl: user.profilePhotoUrl,
                  radius: 32,
                ),
                const SizedBox(height: 10),
                Text(
                  user.name ?? "Pengguna",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email ?? "",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isTeacher ? "Guru" : "Siswa",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.school_outlined,
            title: 'Akademik',
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          
          // Different menu items based on user role
          if (isTeacher)
            _buildDrawerItem(
              icon: Icons.assignment_outlined,
              title: 'Rekap Nilai',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur rekap nilai akan segera hadir'))
                );
              },
            ),
          
          if (!isTeacher)
            _buildDrawerItem(
              icon: Icons.score_outlined,
              title: 'Nilai',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur nilai akan segera hadir'))
                );
              },
            ),
          
          if (isTeacher)
            _buildDrawerItem(
              icon: Icons.people_outlined,
              title: 'Daftar Kelas',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur daftar kelas akan segera hadir'))
                );
              },
            ),
          
          if (!isTeacher)
            _buildDrawerItem(
              icon: Icons.book_outlined,
              title: 'Tugas & PR',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur tugas & PR akan segera hadir'))
                );
              },
            ),
          
          const Divider(),
          
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            title: 'Bantuan',
            onTap: () {
              Navigator.pop(context);
              // Navigate to help
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Keluar',
            onTap: () async {
              Navigator.pop(context);
              // Show confirmation dialog
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Keluar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true) {
                await auth.logout();
              }
            },
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'v2.1.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildScheduleTab(BuildContext context, bool isTeacher) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            size: 120,
            color: Colors.indigo.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            isTeacher ? 'Jadwal Mengajar' : 'Jadwal Pelajaran',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isTeacher 
                ? 'Fitur jadwal mengajar akan segera hadir'
                : 'Fitur jadwal pelajaran akan segera hadir',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab(BuildContext context, bool isTeacher) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fact_check,
            size: 120,
            color: Colors.indigo.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            isTeacher ? 'Rekap Absensi Kelas' : 'Absensi Siswa',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isTeacher 
                ? 'Fitur rekap absensi kelas akan segera hadir'
                : 'Fitur absensi siswa akan segera hadir',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context, bool isTeacher) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.user;
    
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Profile Avatar with larger radius
          Center(
            child: Stack(
              children: [
                ProfileAvatar(
                  imageUrl: user.profilePhotoUrl,
                  radius: 60,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // User name
          Text(
            user.name ?? "Pengguna",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // User email
          Text(
            user.email ?? "",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          // User role
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isTeacher ? "Guru" : "Siswa",
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Profile menu items
          _buildProfileMenuItem(
            title: 'Pengaturan Akun',
            icon: Icons.settings,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur pengaturan akun akan segera hadir'))
              );
            },
          ),
          _buildProfileMenuItem(
            title: 'Notifikasi',
            icon: Icons.notifications,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur notifikasi akan segera hadir'))
              );
            },
          ),
          _buildProfileMenuItem(
            title: 'Keamanan',
            icon: Icons.security,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur keamanan akan segera hadir'))
              );
            },
          ),
          _buildProfileMenuItem(
            title: 'Bantuan & Dukungan',
            icon: Icons.help,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur bantuan & dukungan akan segera hadir'))
              );
            },
          ),
          _buildProfileMenuItem(
            title: 'Keluar',
            icon: Icons.logout,
            isLogout: true,
            onTap: () async {
              // Show confirmation dialog
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Keluar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true) {
                await auth.logout();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.indigo,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: isLogout 
            ? null 
            : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
