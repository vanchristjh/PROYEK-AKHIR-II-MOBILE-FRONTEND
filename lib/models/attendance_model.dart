import 'package:flutter/material.dart';

class AttendanceRecord {
  final int id;
  final int sessionId;
  final String date;
  final String subject;
  final String? className;
  final String status;
  final String? notes;
  final String? checkInTime;

  AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.date,
    required this.subject,
    this.className,
    required this.status,
    this.notes,
    this.checkInTime,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      sessionId: json['attendance_id'] ?? json['session_id'],
      date: json['date'] ?? json['session']['date'],
      subject: json['subject'] ?? json['session']['subject'] ?? 'N/A',
      className: json['class_name'] ?? json['session']['class_name'],
      status: json['status'],
      notes: json['notes'],
      checkInTime: json['check_in_time'],
    );
  }

  // Helper method to get the status color
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Colors.green;
      case 'izin':
        return Colors.blue;
      case 'sakit':
        return Colors.orange;
      case 'alpa':
        return Colors.red;
      case 'terlambat':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get the status icon
  IconData getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Icons.check_circle;
      case 'izin':
        return Icons.assignment_turned_in;
      case 'sakit':
        return Icons.healing;
      case 'alpa':
        return Icons.cancel;
      case 'terlambat':
        return Icons.access_time;
      default:
        return Icons.help_outline; // Default icon for unknown status
    }
  }
}

