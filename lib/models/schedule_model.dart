class Schedule {
  final int id;
  final int classId;
  final String className;
  final int teacherId;
  final String teacherName;
  final String subject;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String? room;
  final String? academicYear;
  final int? semester;
  final String? description;
  final bool isActive;

  Schedule({
    required this.id,
    required this.classId,
    required this.className,
    required this.teacherId,
    required this.teacherName,
    required this.subject,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.room,
    this.academicYear,
    this.semester,
    this.description,
    required this.isActive,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      classId: json['class_id'],
      className: json['class_name'] ?? json['class']['name'],
      teacherId: json['teacher_id'],
      teacherName: json['teacher_name'] ?? json['teacher']['name'],
      subject: json['subject'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      room: json['room'],
      academicYear: json['academic_year'],
      semester: json['semester'],
      description: json['description'],
      isActive: json['is_active'] ?? true,
    );
  }

  // Helper method to get localized day name
  String get localizedDay {
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
        return 'Senin';
      case 'tuesday':
        return 'Selasa';
      case 'wednesday':
        return 'Rabu';
      case 'thursday':
        return 'Kamis';
      case 'friday':
        return 'Jumat';
      case 'saturday':
        return 'Sabtu';
      case 'sunday':
        return 'Minggu';
      default:
        return dayOfWeek;
    }
  }

  // Get schedule time range as formatted string
  String get timeRange => '$startTime - $endTime';
}
