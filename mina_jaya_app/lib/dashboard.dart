// lib/home_page.dart

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Home

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Background diubah jadi PUTIH
      backgroundColor: const Color.fromARGB(255, 230, 230, 230), // <-- DIUBAH
      // 3. Body Utama
      body: SingleChildScrollView(
        // Kita HAPUS padding utama di sini
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GAMBAR BANNER (FULL-WIDTH) ---
            // Widget ini sekarang TIDAK dibungkus Padding
            Image.asset(
              'assets/tambak_page.jpeg',
              width: double.infinity,
              height: 200, // Sedikit lebih tinggi agar pas
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(),
                );
              },
            ),

            // --- KONTEN LAIN DENGAN PADDING ---
            // Semua konten lain kita bungkus dengan Padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STATISTIK KOLAM',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), // <-- DIUBAH
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- KARTU STATISTIK (HORIZONTAL SCROLL) ---
                  SizedBox(
                    height: 145,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildStatCard(
                          iconWidget: const Icon(
                            Icons.thermostat,
                            color: Colors.white,
                            size: 30,
                          ),
                          title: 'Suhu Kolam',
                          value: '42 °C',
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          iconWidget: const Icon(
                            Icons.opacity,
                            color: Colors.white,
                            size: 30,
                          ),
                          title: 'pH Air Kolam',
                          value: '6.20',
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          iconWidget: const Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 30,
                          ),
                          title: 'Status Pakan',
                          value: 'Diberikan',
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          iconWidget: const Text(
                            'O²',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: 'Kadar Oksigen Air',
                          value: '',
                          color: Colors.red.shade700,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- KARTU JENIS IKAN (DONUT CHART) ---
                  _buildJenisIkanCard(),
                  const SizedBox(height: 16),

                  // --- KARTU STATUS SENSOR ---
                  _buildStatusSensorCard(),
                  const SizedBox(height: 16),

                  // --- FOOTER TEXT ---
                  Center(
                    child: Text(
                      'Tambak Kiri Mina Jaya ©2025',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ), // <-- DIUBAH
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),

      // 4. Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: 'Statistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal_outlined),
            label: 'Pakan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Stok',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 71, 131, 216),
        selectedItemColor: const Color.fromARGB(255, 157, 240, 255),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        elevation: 8.0, // <-- DITAMBAHKAN (untuk bayangan)
      ),
    );
  }

  // --- WIDGET BANTUAN ---

  // (Tidak ada perubahan di _buildStatCard)
  Widget _buildStatCard({
    required Widget iconWidget,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconWidget,
          const Spacer(),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk kartu "Jenis Ikan"
  Widget _buildJenisIkanCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Tetap putih
        borderRadius: BorderRadius.circular(12.0),
        // <-- DITAMBAHKAN BoxShadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // Posisi bayangan
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jenis Ikan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Icon(
                  Icons.donut_large,
                  size: 120,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem(
                      Colors.blue.shade800,
                      'Ikan Mujair',
                      '40%',
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(Colors.green.shade600, 'Ikan Lele', '25%'),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      Colors.orange.shade500,
                      'Ikan Nila',
                      '20%',
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(Colors.cyan.shade400, 'Ikan Patin', '15%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // (Tidak ada perubahan di _buildLegendItem)
  Widget _buildLegendItem(Color color, String title, String percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
        const Spacer(),
        Text(percentage, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Widget untuk kartu "Status Sensor"
  Widget _buildStatusSensorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Tetap putih
        borderRadius: BorderRadius.circular(12.0),
        // <-- DITAMBAHKAN BoxShadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // Posisi bayangan
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Sensor Kolam',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildLegendItem(Colors.blue, 'Total Sensor', '12'),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.green, 'Sensor Aktif', '12'),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.grey, 'Sensor Inaktif', '0'),
          const Divider(height: 24),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Periksa Selengkapnya >',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
