import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'detail_sensor.dart';
import 'notification.dart';
import 'profile_page.dart';
import 'services/dashboard_service.dart'; // [BARU] Import Service

// [UBAH] Jadi StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable Data
  bool _isLoading = true;
  Map<String, dynamic> _sensorData = {
    'suhu': 0,
    'ph': 0,
    'oksigen': 0,
  };
  List<dynamic> _pieChartData = [];

  // Warna untuk Pie Chart (Urutan warna)
  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final service = DashboardService();
    final data = await service.getDashboardData();

    if (data != null) {
      setState(() {
        _sensorData = data['sensor'];
        _pieChartData = data['pie_chart']; // Format: [{jenis_ikan: 'Nila', total: 5}, ...]
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung Total Ikan untuk Persentase
    int totalSemuaIkan = 0;
    for (var item in _pieChartData) {
      totalSemuaIkan += int.parse(item['total'].toString());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar sudah di handle di Main Page?
      // Jika Dashboard berdiri sendiri pakai Scaffold body.
      // Tapi jika dipanggil di MainPage, kita sesuaikan padding atasnya.
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/tambak.png', // Pastikan nama file gambar benar
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey))
                  ),
                ),
              ),
            ),

            // Statistik Horizontal (DATA DARI API)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Statistik Sensor Terkini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard('Suhu Air', '${_sensorData['suhu']}°C', Colors.blue),
                  const SizedBox(width: 12),
                  _buildStatCard('pH Air', '${_sensorData['ph']}', Colors.green),
                  const SizedBox(width: 12),
                  // Oksigen ambil dari API, jika 0 tampilkan strip
                  _buildStatCard('Oksigen (DO)', '${_sensorData['oksigen']} mg/L', Colors.purple),
                  const SizedBox(width: 12),
                  // Status pakan statis dulu atau logic tersendiri
                  _buildStatCard('Status Pakan', 'Aman', Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Grafik Ikan (Pie Chart DINAMIS)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Komposisi Ikan dalam Tambak',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_pieChartData.isEmpty)
              const Center(child: Text("Belum ada data kolam aktif.", style: TextStyle(color: Colors.grey)))
            else
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: List.generate(_pieChartData.length, (index) {
                      final ikan = _pieChartData[index];
                      final jumlah = int.parse(ikan['total'].toString());
                      final persentase = totalSemuaIkan > 0
                          ? (jumlah / totalSemuaIkan * 100).toStringAsFixed(1)
                          : '0';
                      final color = _colors[index % _colors.length]; // Putar warna

                      return PieChartSectionData(
                        color: color,
                        value: jumlah.toDouble(),
                        title: '${ikan['jenis_ikan']}\n$persentase%',
                        radius: 60,
                        titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      );
                    }),
                  ),
                ),
              ),

            // Legend / Keterangan Warna (Manual Loop)
            if (_pieChartData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: List.generate(_pieChartData.length, (index) {
                    final ikan = _pieChartData[index];
                    final color = _colors[index % _colors.length];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 12, height: 12, color: color),
                        const SizedBox(width: 4),
                        Text('${ikan['jenis_ikan']} (${ikan['total']})', style: const TextStyle(fontSize: 12)),
                      ],
                    );
                  }),
                ),
              ),

            const SizedBox(height: 24),

            // Tombol Sensor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailSensorPage()),
                    );
                  },
                  icon: const Icon(Icons.sensors),
                  label: const Text('Lihat Detail Semua Sensor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}