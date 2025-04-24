import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;
  bool _isUploading = false;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phoneNumber);
    _addressController = TextEditingController(text: user?.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadProfilePhoto() async {
    if (_imageFile == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final result = await profileProvider.uploadProfilePhoto(_imageFile!, user.id);

      if (result['success'] && mounted) {
        // Update local user object with new photo URL
        final updatedUser = User(
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          profilePhotoUrl: result['profile_photo_url'],
          nis: user.nis,
          nisn: user.nisn,
          className: user.className,
          classId: user.classId,
          academicYear: user.academicYear,
          nip: user.nip,
          nuptk: user.nuptk,
          subject: user.subject,
          position: user.position,
          phoneNumber: user.phoneNumber,
          address: user.address,
          gender: user.gender,
          birthDate: user.birthDate,
        );

        authProvider.updateUserProfile(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileProvider.errorMessage ?? 'Gagal mengupload foto'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _imageFile = null;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) return;

    // Only include fields that have changed
    final Map<String, dynamic> updatedData = {};
    if (_nameController.text != user.name) {
      updatedData['name'] = _nameController.text;
    }
    if (_phoneController.text != user.phoneNumber) {
      updatedData['phone_number'] = _phoneController.text;
    }
    if (_addressController.text != user.address) {
      updatedData['address'] = _addressController.text;
    }

    // Don't submit if nothing has changed
    if (updatedData.isEmpty) {
      setState(() {
        _isEditing = false;
      });
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final result = await profileProvider.updateProfile(user.id, updatedData);

      if (result['success'] && mounted) {
        // Update local user object with new data
        final updatedUser = User(
          id: user.id,
          name: updatedData['name'] ?? user.name,
          email: user.email,
          role: user.role,
          profilePhotoUrl: user.profilePhotoUrl,
          nis: user.nis,
          nisn: user.nisn,
          className: user.className,
          classId: user.classId,
          academicYear: user.academicYear,
          nip: user.nip,
          nuptk: user.nuptk,
          subject: user.subject,
          position: user.position,
          phoneNumber: updatedData['phone_number'] ?? user.phoneNumber,
          address: updatedData['address'] ?? user.address,
          gender: user.gender,
          birthDate: user.birthDate,
        );

        authProvider.updateUserProfile(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          _isEditing = false;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileProvider.errorMessage ?? 'Gagal memperbarui profil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isLoading = _isUploading || profileProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: isLoading ? null : _updateProfile,
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() {
                        _isEditing = false;
                        _nameController.text = user?.name ?? '';
                        _phoneController.text = user?.phoneNumber ?? '';
                        _addressController.text = user?.address ?? '';
                      });
                    },
            ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile photo and upload
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!) as ImageProvider
                              : user.profilePhotoUrl != null
                                  ? NetworkImage(user.profilePhotoUrl!) as ImageProvider
                                  : null,
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: user.profilePhotoUrl == null && _imageFile == null
                              ? Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: IconButton(
                              icon: Icon(
                                _imageFile != null ? Icons.check : Icons.photo_camera,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : _imageFile != null
                                      ? _uploadProfilePhoto
                                      : _pickImage,
                            ),
                          ),
                        ),
                        if (isLoading)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User information form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Basic information
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
                                  'Informasi Dasar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _nameController,
                                  enabled: _isEditing,
                                  decoration: const InputDecoration(
                                    labelText: 'Nama Lengkap',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  enabled: false,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                if (user.role == 'student')
                                  Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      _buildReadOnlyField(
                                        label: 'NIS',
                                        value: user.nis ?? 'N/A',
                                      ),
                                      const SizedBox(height: 16),
                                      _buildReadOnlyField(
                                        label: 'NISN',
                                        value: user.nisn ?? 'N/A',
                                      ),
                                      const SizedBox(height: 16),
                                      _buildReadOnlyField(
                                        label: 'Kelas',
                                        value: user.className ?? 'N/A',
                                      ),
                                    ],
                                  ),
                                if (user.role == 'teacher')
                                  Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      _buildReadOnlyField(
                                        label: 'NIP',
                                        value: user.nip ?? 'N/A',
                                      ),
                                      const SizedBox(height: 16),
                                      _buildReadOnlyField(
                                        label: 'Mata Pelajaran',
                                        value: user.subject ?? 'N/A',
                                      ),
                                      const SizedBox(height: 16),
                                      _buildReadOnlyField(
                                        label: 'Jabatan',
                                        value: user.position ?? 'N/A',
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Contact information
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
                                  'Informasi Kontak',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _phoneController,
                                  enabled: _isEditing,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Nomor Telepon',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _addressController,
                                  enabled: _isEditing,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: 'Alamat',
                                    border: OutlineInputBorder(),
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Additional information
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
                                  'Informasi Lainnya',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildReadOnlyField(
                                  label: 'Jenis Kelamin',
                                  value: user.gender == 'L'
                                      ? 'Laki-laki'
                                      : user.gender == 'P'
                                          ? 'Perempuan'
                                          : 'N/A',
                                ),
                                const SizedBox(height: 16),
                                _buildReadOnlyField(
                                  label: 'Tanggal Lahir',
                                  value: user.birthDate ?? 'N/A',
                                ),
                              ],
                            ),
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

  Widget _buildReadOnlyField({required String label, required String value}) {
    return TextField(
      controller: TextEditingController(text: value),
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
