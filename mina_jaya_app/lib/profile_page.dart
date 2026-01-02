import 'package:flutter/material.dart';
import 'login.dart';
import 'services/auth_service.dart';
import 'edit_profile_page.dart'; // [PENTING] Import halaman edit
import 'admin_user_page.dart';   // [PENTING] Import halaman admin

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  String userId = '';
  String joinDate = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Fungsi ambil data dari Service
  void _loadUserProfile() async {
    final authService = AuthService();
    final userData = await authService.getUserProfile();

    if (userData != null) {
      setState(() {
        name = userData['name'] ?? 'User';
        email = userData['email'] ?? '-';

        // Sesuaikan dengan nama kolom database kamu (phone/no_hp)
        phone = userData['phone'] ?? userData['no_hp'] ?? '-';

        // Sesuaikan dengan nama kolom database kamu (address/alamat)
        address = userData['address'] ?? userData['alamat'] ?? '-';

        role = userData['role'] ?? 'Anggota';
        userId = userData['id'].toString();

        String rawDate = userData['created_at'] ?? '';
        joinDate = rawDate.length > 10 ? rawDate.substring(0, 10) : rawDate;

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi Logout
  void _handleLogout(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
      }

      await AuthService().logout();

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profil Pengguna"),
        backgroundColor: const Color(0xFF005A9C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // [DATA DINAMIS] Nama
                  Text(
                    name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // [DATA DINAMIS] Role
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: role == 'admin' ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      role.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // [DATA DINAMIS] Tanggal Join
                  Text(
                    "Bergabung sejak $joinDate",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // [DATA DINAMIS] Info Detail
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInfoItem(Icons.email_outlined, "Email Address", email)),
                      Expanded(child: _buildInfoItem(Icons.location_on_outlined, "Alamat / Lokasi", address)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInfoItem(Icons.phone_outlined, "Nomor Telepon", phone)),
                      Expanded(child: _buildInfoItem(Icons.fingerprint, "User ID", "#$userId")),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // 1. Siapkan data saat ini untuk dikirim ke halaman edit
                      Map<String, dynamic> currentUserData = {
                        'name': name,
                        'email': email,
                        'phone': phone,
                        'address': address,
                      };

                      // 2. Buka halaman EditProfilePage
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(userData: currentUserData),
                        ),
                      );

                      // 3. Jika berhasil edit (result == true), refresh halaman ini
                      if (result == true) {
                        _loadUserProfile();
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text("Edit Profil"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue[700],
                      elevation: 0,
                      side: BorderSide(color: Colors.blue.shade100),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text("Keluar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      side: BorderSide(color: Colors.red.shade100),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),

            // [BARU] Tombol Khusus Admin
            // Hanya muncul jika role user adalah 'admin'
            if (role == 'admin')
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminUserPage())
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text("Halaman Admin (Kelola User)"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.blue[700]),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            overflow: TextOverflow.ellipsis, // Agar teks panjang tidak error
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}