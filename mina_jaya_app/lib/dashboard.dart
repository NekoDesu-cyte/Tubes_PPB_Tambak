import 'package:flutter/material.dart';
import 'statistik.dart';
import 'detail_sensor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Image.asset(
              'assets/tambak_page.jpeg',
              width: double.infinity,
              height: 200,
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

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DASHBOARD KOLAM',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kartu Warna Warni yang bisa horizontal Scroll
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
                  _buildJenisIkanCard(),
                  const SizedBox(height: 16),
                  _buildStatusSensorCard(context),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Tambak Kiri Mina Jaya ©2025',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CircleAvatar(
        radius: 20, 
        backgroundColor: Colors.blue[700], 
        child: Icon(
          icon,
          color: Colors.white, 
          size: 20, 
        ),
      ),
    );
  }
  // --------------------------------------------------

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

  Widget _buildJenisIkanCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
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

  Widget _buildStatusSensorCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailSensorPage(),
                ),
              );
            },
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