class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? profilePhotoUrl;
  final String? address;
  final String? phoneNumber;
  final String? gender;
  final String? dateOfBirth;
  final String? createdAt;
  final String? updatedAt;

  // Additional fields for students
  final String? nisn;
  final String? className;

  // Additional fields for teachers
  final String? nip;
  final String? subject;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePhotoUrl,
    this.address,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.nisn,
    this.className,
    this.nip,
    this.subject,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'user',
      profilePhotoUrl: json['profile_photo_url'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      // Student specific fields
      nisn: json['nisn'],
      className: json['class_name'],
      // Teacher specific fields
      nip: json['nip'],
      subject: json['subject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profile_photo_url': profilePhotoUrl,
      'address': address,
      'phone_number': phoneNumber,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'nisn': nisn,
      'class_name': className,
      'nip': nip,
      'subject': subject,
    };
  }

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isAdmin => role == 'admin';

  // Create a copy of this user with updated fields
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? profilePhotoUrl,
    String? address,
    String? phoneNumber,
    String? gender,
    String? dateOfBirth,
    String? createdAt,
    String? updatedAt,
    String? nisn,
    String? className,
    String? nip,
    String? subject,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nisn: nisn ?? this.nisn,
      className: className ?? this.className,
      nip: nip ?? this.nip,
      subject: subject ?? this.subject,
    );
  }
}
