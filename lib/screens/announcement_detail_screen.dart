import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import '../providers/announcement_provider.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final int announcementId;
  
  const AnnouncementDetailScreen({
    Key? key,
    required this.announcementId,
  }) : super(key: key);

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMMM yyyy').format(date);
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
  
  String _getPriorityText(int priority) {
    switch (priority) {
      case 3:
        return 'PENTING';
      case 2:
        return 'PERHATIAN';
      case 1:
        return 'INFORMASI';
      default:
        return 'UMUM';
    }
  }

  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    final announcement = announcementProvider.getAnnouncementById(announcementId);
    
    if (announcement == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pengumuman')),
        body: const Center(child: Text('Pengumuman tidak ditemukan')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
              Hero(
                tag: 'announcement-image-${announcement.id}',
                child: Image.network(
                  announcement.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(announcement.priority),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _getPriorityText(announcement.priority),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(announcement.publishedAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    announcement.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (announcement.author != null && announcement.author!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Oleh: ${announcement.author}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const Divider(height: 32),
                  // Check if content might be HTML
                  announcement.content.contains('<') && announcement.content.contains('>')
                      ? Html(
                          data: announcement.content,
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              lineHeight: LineHeight(1.6),
                            ),
                            "p": Style(
                              margin: Margins.only(bottom: 16),
                            ),
                          },
                        )
                      : Text(
                          announcement.content,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
