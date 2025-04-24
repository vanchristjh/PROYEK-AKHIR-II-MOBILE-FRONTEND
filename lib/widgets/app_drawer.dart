import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: user?.profilePhotoUrl != null
                  ? NetworkImage(user!.profilePhotoUrl!)
                  : null,
              child: user?.profilePhotoUrl == null
                  ? Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            accountName: Text(user?.name ?? 'Pengguna'),
            accountEmail: Text(user?.email ?? 'email@example.com'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Jadwal'),
            onTap: () {
              Navigator.of(context).pushNamed('/schedule');
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Absensi'),
            onTap: () {
              Navigator.of(context).pushNamed('/attendance');
            },
          ),
          ListTile(
            leading: const Icon(Icons.announcement),
            title: const Text('Pengumuman'),
            onTap: () {
              Navigator.of(context).pushNamed('/announcements');
            },
          ),
          const Divider(),
          if (user?.role == 'teacher')
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Kelas Saya'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/my-classes');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text('Materi Pelajaran'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/teaching-materials');
                  },
                ),
              ],
            ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Ya'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await authProvider.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
