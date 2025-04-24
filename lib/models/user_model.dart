import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? profilePhotoUrl; // Made this optional (nullable)
  final String? phoneNumber;
  final String? address;
  
  // Student-specific fields
  final String? nis;
  final String? nisn;
  final int? classId;
  final String? className;
  final String? academicYear;
  
  // Teacher-specific fields
  final String? nip;
  final String? nuptk;
  final String? subject;
  final String? position;
  
  // Additional fields
  final String? gender;
  final String? birthDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.profilePhotoUrl, // Optional
    this.phoneNumber,
    this.address,
    this.nis,
    this.nisn,
    this.classId,
    this.className,
    this.academicYear,
    this.nip,
    this.nuptk,
    this.subject,
    this.position,
    this.gender,
    this.birthDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profilePhotoUrl: json['profile_photo_url'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      nis: json['nis'],
      nisn: json['nisn'],
      classId: json['class_id'],
      className: json['class_name'],
      academicYear: json['academic_year'],
      nip: json['nip'],
      nuptk: json['nuptk'],
      subject: json['subject'],
      position: json['position'],
      gender: json['gender'],
      birthDate: json['birth_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profile_photo_url': profilePhotoUrl,
      'phone_number': phoneNumber,
      'address': address,
      'nis': nis,
      'nisn': nisn,
      'class_id': classId,
      'class_name': className,
      'academic_year': academicYear,
      'nip': nip,
      'nuptk': nuptk,
      'subject': subject,
      'position': position,
      'gender': gender,
      'birth_date': birthDate,
    };
  }
}
