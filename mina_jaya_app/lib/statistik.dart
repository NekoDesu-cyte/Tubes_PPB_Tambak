import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';
import 'services/kolam_service.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  List<double> suhu = [];
  List<double> ph = [];
  List<double> oksigen = [];
  List<dynamic> _kolamList = [];
  bool isLoading = true;

  final KolamService _kolamService = KolamService();

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  // Fungsi buat load data JSON untuk chart
  Future<void> loadJsonData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/statistik.json');
      final dataChart = json.decode(response);

      final dataKolamAPI = await _kolamService.getKolam();

      setState(() {
        // Data Kolam
        _kolamList = dataKolamAPI;

        isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat data: $e');
      setState(() => isLoading = false);
    }
  }

  // Cetakan untuk bikin Line Chart
  LineChartData _buildLineChartData(List<double> values) {
    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
              values.length, (i) => FlSpot(i.toDouble(), values[i].toDouble())),
          isCurved: true,
          color: const Color(0xFF3889D5),
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  // Cetakan untuk kartu yang ngebungkus chart
  Widget _buildChartCard(String title, List<double> values) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF005A9C),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.8,
              child: LineChart(_buildLineChartData(values)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data Kolam',
                          style: TextStyle(
                            color: Color(0xFF005A9C),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildDataKolamSection(),

                        const SizedBox(height: 32),
                        const Center(
                          child: Text(
                            'Tambak Ikan Mina Jaya ©2025',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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

  Widget _buildDataKolamSection() {
    if (_kolamList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("Data Kolam tidak tersedia")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._kolamList.map((kolam) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildKolamCard(kolam),
          );
        }).toList(),
      ],
    );
  }

  // Card kolamnya
  Widget _buildKolamCard(Map<String, dynamic> kolamData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
          Text(
            kolamData['nama_kolam'] ?? 'Tanpa Nama', // Sesuai DB
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKolamInfoItem('Jenis Ikan', kolamData['jenis_ikan'] ?? '-'),
                    const SizedBox(height: 12),
                    _buildKolamInfoItem('Suhu Air', "${kolamData['suhu_air']}°C"),
                    const SizedBox(height: 12),
                    _buildKolamInfoItem('PH Air', kolamData['ph_air'].toString()),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKolamInfoItem('Status Pakan', kolamData['status_pakan'] ?? '-'),
                    const SizedBox(height: 12),
                    // Note: Jika di DB tidak ada kolom oksigen, bisa di hardcode atau tambah kolom baru
                    _buildKolamInfoItem('Status Kolam', kolamData['status'] ?? 'Aktif'),
                    const SizedBox(height: 12),
                    _buildKolamInfoItem('Pemilik', kolamData['pemilik'] ?? '-'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildKolamInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
      ],
    );
  }
}