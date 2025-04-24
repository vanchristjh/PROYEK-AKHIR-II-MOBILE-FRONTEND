class Announcement {
  final int id;
  final String title;
  final String content;
  final String? excerpt;
  final String publishedAt;
  final String? imageUrl;
  final String? author;
  final int priority;
  final bool isActive;
  final String? targetAudience;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    this.excerpt,
    required this.publishedAt,
    this.imageUrl,
    this.author,
    required this.priority,
    required this.isActive,
    this.targetAudience,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      excerpt: json['excerpt'],
      publishedAt: json['published_at'],
      imageUrl: json['image_url'],
      author: json['author'],
      priority: json['priority'] ?? 0,
      isActive: json['is_active'] ?? true,
      targetAudience: json['target_audience'],
    );
  }
}
