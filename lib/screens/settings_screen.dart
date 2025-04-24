import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationsEnabled = true;
  bool _isDarkModeEnabled = false;
  String _appVersion = '1.0.0';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load app version
      final packageInfo = await PackageInfo.fromPlatform();
      
      setState(() {
        _appVersion = packageInfo.version;
        // Here you would typically load user preferences from SharedPreferences
        // For now we'll use hardcoded defaults
        _isDarkModeEnabled = ThemeMode.system == ThemeMode.dark;
      });
    } catch (e) {
      // Handle errors
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout dari aplikasi?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // Account settings
                _buildSectionHeader('Akun'),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profil Saya'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.password),
                  title: const Text('Ubah Password'),
                  onTap: () {
                    // Navigate to change password screen
                  },
                ),
                const Divider(),
                
                // Application settings
                _buildSectionHeader('Aplikasi'),
                SwitchListTile(
                  title: const Text('Notifikasi'),
                  subtitle: const Text('Terima pemberitahuan dari aplikasi'),
                  secondary: const Icon(Icons.notifications),
                  value: _isNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isNotificationsEnabled = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Mode Gelap'),
                  subtitle: const Text('Ubah tampilan aplikasi'),
                  secondary: const Icon(Icons.dark_mode),
                  value: _isDarkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isDarkModeEnabled = value;
                    });
                    // Here you would typically save the preference and update the theme
                  },
                ),
                const Divider(),
                
                // About
                _buildSectionHeader('Tentang'),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Tentang Sekolah'),
                  onTap: () {
                    // Show school information dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('SMA N 1 Girsang Sipangan Bolon'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'SMA N 1 Girsang Sipangan Bolon adalah sekolah menengah atas negeri yang berlokasi di Girsang Sipangan Bolon.',
                                style: TextStyle(height: 1.5),
                              ),
                              SizedBox(height: 16),
                              Text('Alamat:'),
                              Text('Jalan Pendidikan No. 1, Girsang Sipangan Bolon'),
                              SizedBox(height: 16),
                              Text('Telepon:'),
                              Text('+62 123 4567 890'),
                              SizedBox(height: 16),
                              Text('Email:'),
                              Text('info@sman1girsangsipanganbolon.sch.id'),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Tentang Aplikasi'),
                  onTap: () {
                    // Show about app dialog
                    showAboutDialog(
                      context: context,
                      applicationName: 'SMA N 1 Girsang Sipangan Bolon',
                      applicationVersion: _appVersion,
                      applicationIcon: Image.asset(
                        'assets/images/logo.jpg',
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.school, size: 50);
                        },
                      ),
                      applicationLegalese: '© 2023 SMA N 1 Girsang Sipangan Bolon',
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Aplikasi resmi SMA N 1 Girsang Sipangan Bolon untuk siswa dan guru.',
                          style: TextStyle(height: 1.5),
                        ),
                      ],
                    );
                  },
                ),
                const Divider(),
                
                // Logout
                _buildSectionHeader('Lainnya'),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red[700]),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  onTap: _showLogoutConfirmationDialog,
                ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1,
        ),
      ),
    );
  }
}
