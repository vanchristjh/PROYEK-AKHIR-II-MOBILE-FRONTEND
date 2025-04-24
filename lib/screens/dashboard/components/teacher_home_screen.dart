import 'package:flutter/material.dart';
import '../../../widgets/dashboard_card.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        
        // Simulate data fetching
        await Future.delayed(const Duration(seconds: 1));
        
        setState(() {
          _isLoading = false;
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? _buildLoadingIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreetingSection(),
                  const SizedBox(height: 24),
                  
                  // Quick stats
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  
                  // Teaching classes
                  _buildSectionHeader('Kelas yang Diampu'),
                  const SizedBox(height: 12),
                  _buildTeachingClassesList(),
                  const SizedBox(height: 24),
                  
                  // Upcoming schedule
                  _buildSectionHeader('Jadwal Mengajar Hari Ini'),
                  const SizedBox(height: 12),
                  _buildUpcomingSchedule(),
                  const SizedBox(height: 24),
                  
                  // Recent announcements
                  _buildSectionHeader('Pengumuman Terbaru'),
                  const SizedBox(height: 12),
                  _buildAnnouncementsList(),
                  const SizedBox(height: 24),
                  
                  // Teacher tasks
                  _buildSectionHeader('Tugas Guru'),
                  const SizedBox(height: 12),
                  _buildTeacherTasksList(),
                  const SizedBox(height: 30),
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildGreetingSection() {
    final hour = DateTime.now().hour;
    String greeting = 'Selamat Pagi';
    
    if (hour >= 12 && hour < 15) {
      greeting = 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      greeting = 'Selamat Sore';
    } else if (hour >= 18) {
      greeting = 'Selamat Malam';
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.indigo.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Semester Genap 2023/2024',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Jadwal mengajar anda hari ini',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickInfoCard(
                  '3',
                  'Kelas',
                  Icons.class_outlined,
                  Colors.orangeAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickInfoCard(
                  '6',
                  'Jam',
                  Icons.access_time,
                  Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickInfoCard(
                  '2',
                  'Tugas',
                  Icons.assignment_outlined,
                  Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
          ),
          child: Row(
            children: [
              Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade600),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: DashboardCard(
            title: 'Total Kelas',
            count: '5',
            icon: Icons.class_,
            color: Colors.indigo,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DashboardCard(
            title: 'Total Siswa',
            count: '150',
            icon: Icons.people,
            color: Colors.orange,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DashboardCard(
            title: 'Tugas',
            count: '8',
            icon: Icons.assignment,
            color: Colors.green,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTeachingClassesList() {
    // Sample teaching classes data
    final classes = [
      {'name': 'X IPA 1', 'subject': 'Matematika', 'students': 30, 'background': Colors.blue},
      {'name': 'X IPA 2', 'subject': 'Matematika', 'students': 32, 'background': Colors.green},
      {'name': 'XI IPA 1', 'subject': 'Matematika', 'students': 28, 'background': Colors.orange},
      {'name': 'XI IPS 1', 'subject': 'Matematika', 'students': 25, 'background': Colors.purple},
      {'name': 'XII IPA 1', 'subject': 'Matematika', 'students': 26, 'background': Colors.red},
    ];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: classes.map((classData) {
          final Color backgroundColor = classData['background'] as Color? ?? Colors.blue;
          
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${classData['name']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${classData['subject']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${classData['students']} siswa',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: backgroundColor,
                            minimumSize: const Size(double.infinity, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Lihat Kelas'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpcomingSchedule() {
    // Sample schedule data
    final schedules = [
      {
        'class': 'X IPA 1', 
        'subject': 'Matematika',
        'time': '08:00 - 09:30',
        'room': 'R.101',
        'status': 'Akan Datang'
      },
      {
        'class': 'XI IPA 1', 
        'subject': 'Matematika',
        'time': '10:00 - 11:30',
        'room': 'R.201',
        'status': 'Sedang Berlangsung'
      },
      {
        'class': 'X IPA 2', 
        'subject': 'Matematika',
        'time': '13:00 - 14:30',
        'room': 'R.102',
        'status': 'Akan Datang'
      },
    ];
    
    return Column(
      children: schedules.map((schedule) {
        final bool isOngoing = schedule['status'] == 'Sedang Berlangsung';
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              '${schedule['subject']} - ${schedule['class']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${schedule['time']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.room, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${schedule['room']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isOngoing ? Colors.green.shade100 : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    schedule['status'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOngoing ? Colors.green.shade700 : Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isOngoing ? Colors.green : Colors.indigo,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(isOngoing ? 'Masuk Kelas' : 'Absensi'),
            ),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnnouncementsList() {
    // Sample announcements data
    final announcements = [
      {
        'title': 'Rapat Guru',
        'date': '20 Jun 2023',
        'content': 'Rapat evaluasi pembelajaran semester genap akan dilaksanakan pada hari Jumat, 20 Juni 2023 pukul 14.00 WIB di Ruang Rapat Utama.'
      },
      {
        'title': 'Ujian Akhir Semester',
        'date': '15 Jun 2023',
        'content': 'Jadwal UAS telah dirilis. Silahkan cek di sistem akademik untuk melihat jadwal dan ruangan pengawasan.'
      },
    ];
    
    return Column(
      children: announcements.map((announcement) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      announcement['title'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, 
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        announcement['date'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  announcement['content'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Lihat Detail'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTeacherTasksList() {
    // Sample teacher tasks data
    final tasks = [
      {
        'title': 'Input Nilai UTS',
        'class': 'X IPA 1',
        'deadline': '22 Jun 2023',
        'status': 'Belum Selesai',
        'priority': 'Tinggi'
      },
      {
        'title': 'Koreksi Tugas Matematika',
        'class': 'XI IPA 1',
        'deadline': '25 Jun 2023',
        'status': 'Belum Selesai',
        'priority': 'Sedang'
      },
      {
        'title': 'Rapat Wali Kelas',
        'class': 'X IPA 2',
        'deadline': '18 Jun 2023',
        'status': 'Selesai',
        'priority': 'Rendah'
      },
    ];
    
    return Column(
      children: tasks.map((task) {
        final isCompleted = task['status'] == 'Selesai';
        Color priorityColor;
        
        switch(task['priority']) {
          case 'Tinggi':
            priorityColor = Colors.red;
            break;
          case 'Sedang':
            priorityColor = Colors.orange;
            break;
          case 'Rendah':
          default:
            priorityColor = Colors.green;
            break;
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green.shade100 : priorityColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.assignment_outlined,
                color: isCompleted ? Colors.green : priorityColor,
              ),
            ),
            title: Text(
              task['title'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Kelas: ${task['class']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Deadline: ${task['deadline']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: SizedBox(
              width: 80,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: isCompleted ? Colors.green : priorityColor,
                  side: BorderSide(color: isCompleted ? Colors.green : priorityColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(isCompleted ? 'Selesai' : 'Kerjakan'),
              ),
            ),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }
}
