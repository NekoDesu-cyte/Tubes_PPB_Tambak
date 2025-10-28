import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DetailSensorPage extends StatefulWidget {
  const DetailSensorPage({super.key});

  @override
  State<DetailSensorPage> createState() => _DetailSensorPageState();
}

class _DetailSensorPageState extends State<DetailSensorPage> {
  List<dynamic> sensorList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSensorData();
  }

  Future<void> loadSensorData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/sensor.json');
      final data = json.decode(response);
      setState(() {
        sensorList = data['sensor_list'];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Detail Sensor Kolam',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sensorList.isEmpty
              ? const Center(child: Text('Tidak ada data sensor.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      const Text(
                        'Pantauan status sensor aktif & inaktif di setiap kolam.',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      ...sensorList.map((sensor) => _buildSensorCard(sensor)),
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
    );
  }

  Widget _buildSensorCard(Map<String, dynamic> sensor) {
    final bool isActive = sensor['status'] == 'Aktif';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.sensors : Icons.sensors_off,
            color: isActive ? Colors.green : Colors.redAccent,
            size: 36,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sensor['nama'] ?? '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lokasi: ${sensor['lokasi'] ?? '-'}',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${sensor['status'] ?? '-'}',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.redAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            sensor['nilai'] ?? '-',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005A9C),
            ),
          ),
        ],
      ),
    );
  }
}
