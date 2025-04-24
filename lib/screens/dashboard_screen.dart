import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/schedule_provider.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _loadData();
      _isInit = true;
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final announcementProvider = Provider.of<AnnouncementProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);

    await Future.wait([
      announcementProvider.fetchAnnouncements(),
      scheduleProvider.fetchTodaySchedule(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              backgroundImage: user?.profilePhotoUrl != null
                                  ? NetworkImage(user!.profilePhotoUrl!)
                                  : null,
                              child: user?.profilePhotoUrl == null
                                  ? Text(
                                      user?.name.isNotEmpty == true
                                          ? user!.name[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat datang,',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.name ?? 'Pengguna',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.role == 'student'
                                        ? 'Siswa - ${user?.className ?? ''}'
                                        : user?.role == 'teacher'
                                            ? 'Guru - ${user?.subject ?? ''}'
                                            : 'Pengguna',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Menu shortcuts
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildMenuCard(
                          context,
                          icon: Icons.calendar_today,
                          title: 'Jadwal',
                          onTap: () => Navigator.of(context).pushNamed('/schedule'),
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.check_circle,
                          title: 'Absensi',
                          onTap: () => Navigator.of(context).pushNamed('/attendance'),
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.announcement,
                          title: 'Pengumuman',
                          onTap: () => Navigator.of(context).pushNamed('/announcements'),
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.person,
                          title: 'Profil',
                          onTap: () => Navigator.of(context).pushNamed('/profile'),
                        ),
                        if (user?.role == 'teacher')
                          _buildMenuCard(
                            context,
                            icon: Icons.school,
                            title: 'Kelas',
                            onTap: () => Navigator.of(context).pushNamed('/my-classes'),
                          ),
                        _buildMenuCard(
                          context,
                          icon: Icons.settings,
                          title: 'Pengaturan',
                          onTap: () => Navigator.of(context).pushNamed('/settings'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Today's Schedule Section
                    const Text(
                      'Jadwal Hari Ini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (scheduleProvider.todaySchedules.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Tidak ada jadwal untuk hari ini',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: scheduleProvider.todaySchedules.length,
                        itemBuilder: (ctx, index) {
                          final schedule = scheduleProvider.todaySchedules[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    schedule.startTime.substring(0, 5),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                schedule.subject,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                user?.role == 'student'
                                    ? 'Guru: ${schedule.teacherName}'
                                    : 'Kelas: ${schedule.className}',
                              ),
                              trailing: Text(
                                '${schedule.startTime} - ${schedule.endTime}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          );
                        },
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Announcements
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pengumuman Terbaru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/announcements');
                          },
                          child: const Text('Lihat Semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (announcementProvider.announcements.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Tidak ada pengumuman terbaru',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: announcementProvider.announcements.length > 3
                            ? 3
                            : announcementProvider.announcements.length,
                        itemBuilder: (ctx, index) {
                          final announcement = announcementProvider.announcements[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(announcement.priority),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                announcement.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                announcement.excerpt ?? 'Tap untuk membaca lebih lanjut',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                _formatDate(announcement.publishedAt),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/announcement-detail',
                                  arguments: announcement.id,
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 1:
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Hari ini';
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return 'Kemarin';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
