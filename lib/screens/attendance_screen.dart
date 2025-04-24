import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/attendance_provider.dart';
import '../models/attendance_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    await Provider.of<AttendanceProvider>(context, listen: false).fetchAttendanceRecords();
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Riwayat'),
            Tab(text: 'Statistik'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // History tab
                  _buildHistoryTab(attendanceProvider, user?.role ?? ''),
                  
                  // Statistics tab
                  _buildStatisticsTab(attendanceProvider),
                ],
              ),
            ),
    );
  }

  Widget _buildHistoryTab(AttendanceProvider provider, String role) {
    final records = provider.attendanceRecords;

    if (records.isEmpty) {
      return Center(
        child: Text(
          'Belum ada riwayat absensi',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Group attendance records by date
    final Map<String, List<AttendanceRecord>> recordsByDate = {};
    for (final record in records) {
      final date = record.date;
      if (!recordsByDate.containsKey(date)) {
        recordsByDate[date] = [];
      }
      recordsByDate[date]!.add(record);
    }

    // Sort dates in descending order
    final List<String> sortedDates = recordsByDate.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dateRecords = recordsByDate[date]!;
        final formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.parse(date));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dateRecords.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final record = dateRecords[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: record.getStatusColor().withOpacity(0.2),
                      child: Icon(
                        record.getStatusIcon(),
                        color: record.getStatusColor(),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      record.subject,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      role == 'teacher'
                          ? 'Kelas: ${record.className ?? "N/A"}'
                          : 'Status: ${record.status}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          record.checkInTime != null
                              ? 'Pukul: ${record.checkInTime}'
                              : '',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: record.getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            record.status,
                            style: TextStyle(
                              color: record.getStatusColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: record.notes != null && record.notes!.isNotEmpty
                        ? () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Catatan'),
                                content: Text(record.notes!),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildStatisticsTab(AttendanceProvider provider) {
    final summary = provider.getAttendanceSummary();
    final attendancePercentage = provider.getAttendancePercentage();
    final totalRecords = provider.attendanceRecords.length;

    if (totalRecords == 0) {
      return Center(
        child: Text(
          'Belum ada data untuk ditampilkan',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Attendance percentage card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 90,
                            width: 90,
                            child: CircularProgressIndicator(
                              value: attendancePercentage / 100,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                attendancePercentage > 75
                                    ? Colors.green
                                    : attendancePercentage > 50
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${attendancePercentage.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Kehadiran',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Absensi: $totalRecords kali',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStatusRow('Hadir', summary['hadir'] ?? 0, Colors.green, totalRecords),
                        _buildStatusRow('Sakit', summary['sakit'] ?? 0, Colors.orange, totalRecords),
                        _buildStatusRow('Izin', summary['izin'] ?? 0, Colors.blue, totalRecords),
                        _buildStatusRow('Alpa', summary['alpa'] ?? 0, Colors.red, totalRecords),
                        _buildStatusRow('Terlambat', summary['terlambat'] ?? 0, Colors.amber, totalRecords),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Pie chart
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distribusi Status Kehadiran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: summary['hadir']?.toDouble() ?? 0,
                            title: 'Hadir',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.orange,
                            value: summary['sakit']?.toDouble() ?? 0,
                            title: 'Sakit',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.blue,
                            value: summary['izin']?.toDouble() ?? 0,
                            title: 'Izin',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: summary['alpa']?.toDouble() ?? 0,
                            title: 'Alpa',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.amber,
                            value: summary['terlambat']?.toDouble() ?? 0,
                            title: 'Terlambat',
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        startDegreeOffset: 180,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem('Hadir', Colors.green),
                      _buildLegendItem('Sakit', Colors.orange),
                      _buildLegendItem('Izin', Colors.blue),
                      _buildLegendItem('Alpa', Colors.red),
                      _buildLegendItem('Terlambat', Colors.amber),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status, int count, Color color, int total) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(status),
          const Spacer(),
          Text('$count ($percentage%)'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
