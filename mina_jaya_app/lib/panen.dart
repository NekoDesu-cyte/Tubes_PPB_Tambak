import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PanenPage extends StatelessWidget {
  const PanenPage({super.key});

  Future<Map<String, dynamic>> loadPanenData() async {
    final String jsonString = await rootBundle.loadString('assets/data/panen.json');
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadPanenData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          final data = snapshot.data!;
          final totalPanen = data['total_panen'];
          final bibitIkan = data['bibit_ikan'];
          final pokdakan = List<Map<String, dynamic>>.from(data['pokdakan']);

          return SingleChildScrollView(
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
                      width: double.infinity,
                      color: Colors.grey[300],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Panen Ikan',
                        style: TextStyle(
                          color: Color(0xFF005A9C),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPanenCard(
                        title: 'Total Hasil Panen Ikan',
                        value: totalPanen['jumlah'].toString(),
                        unit: totalPanen['satuan'],
                        subtitle: 'Data Terbaru Bulan : ${totalPanen['periode']}',
                      ),
                      const SizedBox(height: 16),
                      _buildPanenCard(
                        title: 'Data Bibit Ikan',
                        value: bibitIkan['jumlah'].toString(),
                        unit: bibitIkan['satuan'],
                        subtitle: 'Data Terbaru Bulan : ${bibitIkan['periode']}',
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Data Hasil Panen POKDAKAN',
                        style: TextStyle(
                          color: Color(0xFF005A9C),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPanenTable(pokdakan),
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
          );
        },
      ),
    );
  }

  Widget _buildPanenCard({
    required String title,
    required String value,
    required String unit,
    required String subtitle,
  }) {
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
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPanenTable(List<Map<String, dynamic>> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Colors.white),
            children: [
              _buildHeaderCell('Batch Panen'),
              _buildHeaderCell('Nama Barang'),
              _buildHeaderCell('Total Berat Batch'),
            ],
          ),
          for (var row in data)
            TableRow(
              decoration: BoxDecoration(
                color: data.indexOf(row) % 2 == 0 ? Colors.grey[50] : Colors.white,
              ),
              children: [
                _buildDataCell(row['batch'].toString()),
                _buildDataCell(row['nama_barang'].toString()),
                _buildDataCell(row['total'].toString()),
              ],
            ),
        ],
      ),
    );
  }

  static TableCell _buildHeaderCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  static TableCell _buildDataCell(String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(text,
            style: const TextStyle(color: Colors.black87, fontSize: 13)),
      ),
    );
  }
}
