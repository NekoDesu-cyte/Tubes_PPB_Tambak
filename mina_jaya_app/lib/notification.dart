import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BG Color
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: const Color(0xFF005A9C), 
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Hari ini'),
            _buildNotificationItem(
              icon: Icons.warning,
              iconColor: Colors.yellow.shade700,
              title: 'Peringatan!',
              subtitle: 'Kadar Oksigen Air di Kolam 2 menurun',
            ),
            _buildNotificationItem(
              icon: Icons.warning, 
              iconColor: Colors.red.shade400,
              title: 'Bahaya!',
              subtitle: 'Suhu Air di Kolam 1 terlalu tinggi',
            ),
            _buildNotificationItem(
              icon: Icons.check, 
              iconColor: Colors.green.shade400,
              title: 'Pemberitahuan',
              subtitle: 'Data Panen Periode September Tahun 2025 Sudah keluar',
            ),
            _buildSectionHeader('Kemarin'),
            _buildNotificationItem(
              icon: Icons.check,
              iconColor: Colors.green.shade400,
              title: 'Pemberitahuan',
              subtitle: 'Data Transaksi Keuangan di Update',
            ),
            _buildNotificationItem(
              icon: Icons.warning,
              iconColor: Colors.red.shade400,
              title: 'Bahaya!',
              subtitle: 'PH air di Kolam 3 terlalu Rendah',
            ),
            _buildSectionHeader('7 Oktober 2025'),
            _buildNotificationItem(
              icon: Icons.warning,
              iconColor: Colors.red.shade400,
              title: 'Bahaya!',
              subtitle: 'Suhu Air di Kolam 3 terlalu tinggi',
            ),
            _buildNotificationItem(
              icon: Icons.warning,
              iconColor: Colors.yellow.shade700,
              title: 'Peringatan!',
              subtitle: 'PH air kolam 1 mengalami penurunan',
            ),
            // ini FOOTER
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(
                child: Text(
                  'Tambak Ikan Mina Jaya ©2025',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF005A9C),
        ),
      ),
    );
  }

  // Widgetnya disini
  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: Colors.white, 
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0), 
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withOpacity(0.2), 
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}