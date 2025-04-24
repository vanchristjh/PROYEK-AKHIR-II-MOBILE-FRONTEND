import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:intl/intl.dart';

class TeachingMaterialsScreen extends StatefulWidget {
  const TeachingMaterialsScreen({Key? key}) : super(key: key);

  @override
  _TeachingMaterialsScreenState createState() => _TeachingMaterialsScreenState();
}

class _TeachingMaterialsScreenState extends State<TeachingMaterialsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _materials = [];
  
  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }
  
  Future<void> _loadMaterials() async {
    setState(() {
      _isLoading = true;
    });
    
    // This would typically come from an API
    // For now, we'll use mock data
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _materials = [
        {
          'id': 1,
          'title': 'Materi Persamaan Kuadrat',
          'subject': 'Matematika',
          'class': 'X IPA 1',
          'type': 'PDF',
          'uploaded_at': '2023-06-15 09:30:00',
          'size': '2.4 MB',
          'download_count': 28,
        },
        {
          'id': 2,
          'title': 'Latihan Soal Trigonometri',
          'subject': 'Matematika',
          'class': 'XI IPA 2',
          'type': 'PDF',
          'uploaded_at': '2023-06-10 14:15:00',
          'size': '1.8 MB',
          'download_count': 35,
        },
        {
          'id': 3,
          'title': 'Presentasi Statistika',
          'subject': 'Matematika',
          'class': 'XII IPA 1',
          'type': 'PPTX',
          'uploaded_at': '2023-06-05 11:00:00',
          'size': '5.2 MB',
          'download_count': 40,
        },
        {
          'id': 4,
          'title': 'Tugas Kalkulus',
          'subject': 'Matematika',
          'class': 'XII IPA 2',
          'type': 'DOCX',
          'uploaded_at': '2023-05-28 10:45:00',
          'size': '750 KB',
          'download_count': 25,
        },
      ];
      _isLoading = false;
    });
  }
  
  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }
  
  IconData _getFileTypeIcon(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'DOCX':
      case 'DOC':
        return Icons.description;
      case 'XLSX':
      case 'XLS':
        return Icons.table_chart;
      case 'PPTX':
      case 'PPT':
        return Icons.slideshow;
      case 'JPG':
      case 'PNG':
      case 'JPEG':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
  
  Color _getFileTypeColor(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return Colors.red;
      case 'DOCX':
      case 'DOC':
        return Colors.blue;
      case 'XLSX':
      case 'XLS':
        return Colors.green;
      case 'PPTX':
      case 'PPT':
        return Colors.orange;
      case 'JPG':
      case 'PNG':
      case 'JPEG':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user?.role != 'teacher') {
      return Scaffold(
        appBar: AppBar(title: const Text('Materi Pelajaran')),
        body: const Center(child: Text('Hanya tersedia untuk guru')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi Pelajaran'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _materials.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada materi pelajaran',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to upload material
                        },
                        child: const Text('Upload Materi'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMaterials,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _materials.length,
                    itemBuilder: (context, index) {
                      final material = _materials[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            // View material details
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _getFileTypeColor(material['type']).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getFileTypeIcon(material['type']),
                                        color: _getFileTypeColor(material['type']),
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            material['title'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Kelas: ${material['class']} • ${material['subject']}',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Diupload: ${_formatDate(material['uploaded_at'])}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.file_present, size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${material['size']} • ${material['type']}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.download, size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${material['download_count']} unduhan',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text('Edit'),
                                      onPressed: () {
                                        // Edit material
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.download, size: 16),
                                      label: const Text('Download'),
                                      onPressed: () {
                                        // Download material
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to upload material
        },
        child: const Icon(Icons.upload_file),
        tooltip: 'Upload Materi',
      ),
    );
  }
}
