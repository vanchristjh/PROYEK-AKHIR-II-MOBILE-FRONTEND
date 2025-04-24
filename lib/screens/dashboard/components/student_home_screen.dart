import 'package:flutter/material.dart';
import '../../../widgets/dashboard_card.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
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
                  
                  // Today's schedule
                  _buildSectionHeader('Jadwal Hari Ini'),
                  const SizedBox(height: 12),
                  _buildTodaySchedule(),
                  const SizedBox(height: 24),
                  
                  // Ongoing subjects/courses
                  _buildSectionHeader('Mata Pelajaran'),
                  const SizedBox(height: 12),
                  _buildSubjectsList(),
                  const SizedBox(height: 24),
                  
                  // Upcoming assignments
                  _buildSectionHeader('Tugas & Ulangan'),
                  const SizedBox(height: 12),
                  _buildAssignmentsList(),
                  const SizedBox(height: 24),
                  
                  // Announcements for students
                  _buildSectionHeader('Pengumuman Terbaru'),
                  const SizedBox(height: 12),
                  _buildAnnouncementsList(),
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
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
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
                  'Kelas X IPA 2',
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
            'Jadwal pelajaran anda hari ini',
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
                  '5',
                  'Pelajaran',
                  Icons.book_outlined,
                  Colors.orangeAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickInfoCard(
                  '8',
                  'Jam',
                  Icons.access_time,
                  Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickInfoCard(
                  '3',
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
            color: Colors.blue,
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.28,
            child: DashboardCard(
              title: 'Presensi',
              count: '95%',
              icon: Icons.history_edu,
              color: Colors.blue,
              onTap: () {},
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.28,
            child: DashboardCard(
              title: 'Nilai Rata-Rata',
              count: '85.5',
              icon: Icons.trending_up,
              color: Colors.orange,
              onTap: () {},
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.28,
            child: DashboardCard(
              title: 'Tugas',
              count: '7',
              icon: Icons.assignment,
              color: Colors.green,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    // Sample schedule data
    final schedules = [
      {
        'subject': 'Matematika',
        'time': '07:00 - 08:30',
        'room': 'R.101',
        'teacher': 'Ibu Siti Aminah',
        'status': 'Selesai'
      },
      {
        'subject': 'Bahasa Inggris',
        'time': '08:30 - 10:00',
        'room': 'R.201',
        'teacher': 'Bpk. Agus Pranoto',
        'status': 'Sedang Berlangsung'
      },
      {
        'subject': 'Fisika',
        'time': '10:15 - 11:45',
        'room': 'R.Lab Fisika',
        'teacher': 'Ibu Ratna Wati',
        'status': 'Akan Datang'
      },
      {
        'subject': 'Biologi',
        'time': '12:30 - 14:00',
        'room': 'R.Lab Biologi',
        'teacher': 'Bpk. Danu Widjaja',
        'status': 'Akan Datang'
      },
    ];
    
    return Column(
      children: schedules.map((schedule) {
        Color statusColor;
        IconData statusIcon;
        
        switch(schedule['status']) {
          case 'Selesai':
            statusColor = Colors.grey;
            statusIcon = Icons.check_circle;
            break;
          case 'Sedang Berlangsung':
            statusColor = Colors.green;
            statusIcon = Icons.play_circle_filled;
            break;
          case 'Akan Datang':
          default:
            statusColor = Colors.orange;
            statusIcon = Icons.access_time_filled;
            break;
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 28,
              ),
            ),
            title: Text(
              schedule['subject'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
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
                      schedule['time'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.room, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      schedule['room'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      schedule['teacher'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: schedule['status'] == 'Sedang Berlangsung'
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Masuk'),
                  )
                : null,
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectsList() {
    // Sample subjects data
    final subjects = [
      {
        'name': 'Matematika',
        'teacher': 'Ibu Siti Aminah',
        'progress': 0.75,
        'color': Colors.blue
      },
      {
        'name': 'Bahasa Inggris',
        'teacher': 'Bpk. Agus Pranoto',
        'progress': 0.65,
        'color': Colors.green
      },
      {
        'name': 'Fisika',
        'teacher': 'Ibu Ratna Wati',
        'progress': 0.45,
        'color': Colors.orange
      },
      {
        'name': 'Biologi',
        'teacher': 'Bpk. Danu Widjaja',
        'progress': 0.82,
        'color': Colors.purple
      },
      {
        'name': 'Kimia',
        'teacher': 'Bpk. Ahmad Faiz',
        'progress': 0.50,
        'color': Colors.red
      },
    ];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: subjects.map((subject) {
          final Color subjectColor = subject['color'] as Color? ?? Colors.blue;
          final double progress = subject['progress'] as double? ?? 0.0;
          
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
                      color: subjectColor.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (subject['name'] as String?) ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (subject['teacher'] as String?) ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(subjectColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: subjectColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text('Detail'),
                          ),
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

  Widget _buildAssignmentsList() {
    // Sample assignments data
    final assignments = [
      {
        'title': 'Tugas Matematika',
        'subject': 'Matematika',
        'deadline': '20 Jun 2023, 23:59',
        'status': 'Belum Dikerjakan',
        'priority': 'Tinggi'
      },
      {
        'title': 'Tugas Bahasa Inggris',
        'subject': 'Bahasa Inggris',
        'deadline': '22 Jun 2023, 23:59',
        'status': 'Sedang Dikerjakan',
        'priority': 'Sedang'
      },
      {
        'title': 'Ulangan Fisika',
        'subject': 'Fisika',
        'deadline': '25 Jun 2023, 10:00',
        'status': 'Akan Datang',
        'priority': 'Tinggi'
      },
    ];
    
    return Column(
      children: assignments.map((assignment) {
        Color priorityColor;
        IconData statusIcon;
        
        switch(assignment['priority']) {
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
        
        switch(assignment['status']) {
          case 'Selesai':
            statusIcon = Icons.check_circle;
            break;
          case 'Sedang Dikerjakan':
            statusIcon = Icons.edit;
            break;
          case 'Belum Dikerjakan':
          case 'Akan Datang':
          default:
            statusIcon = Icons.assignment;
            break;
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: priorityColor,
                size: 28,
              ),
            ),
            title: Text(
              assignment['title'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Mata Pelajaran: ${assignment['subject']}',
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
                      'Deadline: ${assignment['deadline']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Prioritas: ${assignment['priority']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: priorityColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            trailing: SizedBox(
              width: 90,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Kerjakan'),
              ),
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
        'title': 'Libur Semester',
        'date': '25 Jun 2023',
        'content': 'Libur semester genap akan dimulai pada tanggal 26 Juni 2023. Pastikan semua tugas telah dikumpulkan sebelum liburan dimulai.'
      },
      {
        'title': 'Ujian Akhir Semester',
        'date': '15 Jun 2023',
        'content': 'Jadwal UAS telah dirilis. Silahkan cek di papan pengumuman atau di website sekolah untuk detail jadwal dan ruangan ujian.'
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
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        announcement['date'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
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
}
