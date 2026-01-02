import 'package:flutter/material.dart';
import 'services/admin_service.dart';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  final AdminService _adminService = AdminService();
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final users = await _adminService.getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  void _changeRole(int userId, String currentRole, String userName) async {
    // Tentukan role baru (kebalikannya)
    String newRole = currentRole == 'admin' ? 'user' : 'admin';

    // Tampilkan Loading
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mengubah $userName menjadi $newRole...')));

    bool success = await _adminService.updateUserRole(userId, newRole);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil!'), backgroundColor: Colors.green));
      _fetchUsers(); // Refresh list agar tampilan berubah
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengubah role'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen User"),
        backgroundColor: const Color(0xFF005A9C),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          bool isAdmin = user['role'] == 'admin';
          String roleDisplay = isAdmin ? "ADMIN" : "USER BIASA";

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isAdmin ? Colors.orange : Colors.grey,
                child: Icon(isAdmin ? Icons.star : Icons.person, color: Colors.white),
              ),
              title: Text(user['name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${user['email']}\nRole: $roleDisplay"),
              isThreeLine: true,
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAdmin ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                ),
                // Panggil fungsi ubah role
                onPressed: () => _changeRole(user['id'], user['role'], user['name']),
                child: Text(isAdmin ? "Turunkan" : "Jadikan Admin"),
              ),
            ),
          );
        },
      ),
    );
  }
}