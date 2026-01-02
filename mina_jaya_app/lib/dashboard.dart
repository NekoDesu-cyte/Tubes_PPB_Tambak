import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'detail_sensor.dart';
import 'services/dashboard_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  // Data Dummy untuk inisialisasi (akan ditimpa API)
  Map<String, dynamic> _sensorData = {
    'suhu': 0,
    'ph': 0,
    'oksigen': 0,
  };
  List<dynamic> _pieChartData = [];

  // Hitungan Sensor
  int _totalSensor = 3; // Suhu, pH, Oksigen (Pakan dihapus)
  int _sensorAktif = 0;
  int _sensorMati = 0;

  final List<Color> _colors = [
    const Color(0xFF1E88E5), // Biru (Mujair)
    const Color(0xFF43A047), // Hijau (Lele)
    const Color(0xFFFB8C00), // Orange (Nila)
    const Color(0xFF00ACC1), // Cyan (Patin)
    Colors.red,
    Colors.purple,
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
      var sensors = data['sensor'];

      // Hitung Sensor Aktif (Cek Suhu, pH, Oksigen)
      int aktif = 0;
      if (sensors['suhu'] != 0 && sensors['suhu'] != '0') aktif++;
      if (sensors['ph'] != 0 && sensors['ph'] != '0') aktif++;
      if (sensors['oksigen'] != 0 && sensors['oksigen'] != '0') aktif++;

      setState(() {
        _sensorData = data['sensor'];
        _pieChartData = data['pie_chart'];
        _sensorAktif = aktif;
        _sensorMati = _totalSensor - _sensorAktif;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung Total Ikan
    int totalSemuaIkan = 0;
    for (var item in _pieChartData) {
      totalSemuaIkan += int.parse(item['total'].toString());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background abu muda
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Header Image
            Stack(
              children: [
                Image.asset(
                  'assets/tambak_page.jpeg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('Gagal memuat gambar'),
                      ),
                    );
                  },
                ),
                // Overlay Gradient (Opsional biar teks AppBar terbaca)
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JUDUL SECTION
                  const Text(
                    "DASHBOARD KOLAM",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. KARTU SENSOR (SUHU, PH, OKSIGEN)
                  // Menggunakan Row & Expanded agar ukuran menyesuaikan
                  Row(
                    children: [
                      Expanded(
                        child: _buildSensorCard(
                          title: "Suhu Kolam",
                          value: "${_sensorData['suhu']} °C",
                          icon: Icons.thermostat,
                          color: const Color(0xFF1976D2), // Biru
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSensorCard(
                          title: "pH Air Kolam",
                          value: "${_sensorData['ph']}",
                          icon: Icons.water_drop,
                          color: const Color(0xFFF57C00), // Orange
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Oksigen taruh bawahnya (Full width atau row lagi)
                  // Biar rapi, Oksigen kita taruh sendiri tapi style sama
                  _buildSensorCard(
                    title: "Oksigen (DO)",
                    value: "${_sensorData['oksigen']} mg/L",
                    icon: Icons.air,
                    color: const Color(0xFF7B1FA2), // Ungu
                    isFullWidth: true,
                  ),

                  const SizedBox(height: 20),

                  // 3. JENIS IKAN (PIE CHART + LEGEND)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Jenis Ikan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),

                        if (_pieChartData.isEmpty)
                          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("Data Kosong")))
                        else
                          Row(
                            children: [
                              // BAGIAN KIRI: CHART
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 35, // Bolong tengah (Donut)
                                    sections: List.generate(_pieChartData.length, (index) {
                                      final ikan = _pieChartData[index];
                                      final jumlah = int.parse(ikan['total'].toString());
                                      final color = _colors[index % _colors.length];
                                      return PieChartSectionData(
                                        color: color,
                                        value: jumlah.toDouble(),
                                        title: '', // Hapus judul di chart
                                        radius: 25,
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),

                              // BAGIAN KANAN: LEGEND LIST
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(_pieChartData.length, (index) {
                                    final ikan = _pieChartData[index];
                                    final jumlah = int.parse(ikan['total'].toString());
                                    final persentase = totalSemuaIkan > 0
                                        ? (jumlah / totalSemuaIkan * 100).toStringAsFixed(0)
                                        : '0';
                                    final color = _colors[index % _colors.length];

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(radius: 5, backgroundColor: color),
                                              const SizedBox(width: 8),
                                              Text(ikan['jenis_ikan'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                          Text("$persentase%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. STATUS SENSOR KOLAM (LIST)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Status Sensor Kolam", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),

                        _buildStatusListRow("Total Sensor", "$_totalSensor", Colors.blue),
                        const Divider(height: 24),
                        _buildStatusListRow("Sensor Aktif", "$_sensorAktif", Colors.green),
                        const Divider(height: 24),
                        _buildStatusListRow("Sensor Inaktif", "$_sensorMati", Colors.grey),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Detail (Opsional)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailSensorPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Lihat Detail Sensor", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET CARD SENSOR (KOTAK WARNA)
  Widget _buildSensorCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // WIDGET ROW STATUS LIST (TITIK WARNA - TEKS - ANGKA)
  Widget _buildStatusListRow(String label, String value, Color dotColor) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: dotColor),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}