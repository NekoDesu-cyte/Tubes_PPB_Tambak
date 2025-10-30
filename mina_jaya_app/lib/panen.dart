import 'dart:convert';
import 'package:flutter/material.dart';
// Ini buat ngambil file dari folder assets
import 'package:flutter/services.dart' show rootBundle;

class PanenPage extends StatelessWidget {
  const PanenPage({super.key});

  // Ini fungsi buat ngambil data dari file JSON
  // 'Future' artinya dia butuh waktu (ga instan), jadi kita harus 'await' (nunggu)
  Future<Map<String, dynamic>> loadPanenData() async {
    // 1. Ambil file panen.json sebagai Teks/String
    final String jsonString =
        await rootBundle.loadString('assets/data/panen.json');
    // 2. Ubah teks JSON tadi jadi format data (Map) yang bisa dibaca Dart
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),

      // 'FutureBuilder' ini widget ajaib.
      // Dia bakal nge-jalanin fungsi 'future' (loadPanenData)
      // Sambil nunggu, dia bisa nampilin loading. Kalo udah dapet data, dia nampilin 'builder'.
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadPanenData(), // Ini fungsi yang kita panggil
        builder: (context, snapshot) {
          // --- KONDISI 1: LAGI NUNGGU DATA ---
          // Kalo datanya lagi di-load, tampilin logo muter-muter
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());

            // --- KONDISI 2: ADA ERROR ---
            // Kalo ada error (misal file ga ketemu atau JSON-nya rusak)
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));

            // --- KONDISI 3: DATANYA KOSONG ---
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          // --- KONDISI 4: SUKSES DAPET DATA ---
          // Oke, data aman! Kita ambil datanya dari 'snapshot'
          final data = snapshot.data!;
          // Kita pecah-pecah datanya biar gampang dipake
          final totalPanen = data['total_panen'];
          final bibitIkan = data['bibit_ikan'];
          final pokdakan = List<Map<String, dynamic>>.from(data['pokdakan']);

          // 'SingleChildScrollView' bikin halaman ini bisa di-scroll
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ini gambar banner di paling atas
                Image.asset(
                  'assets/tambak_page.jpeg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  // 'errorBuilder' buat jaga-jaga kalo gambar gagal di-load
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                    );
                  },
                ),
                // 'Padding' ini buat ngasih jarak pinggir ke semua konten di bawah banner
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul "Panen Ikan"
                      const Text(
                        'Panen Ikan',
                        style: TextStyle(
                          color: Color(0xFF005A9C),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ini kita panggil 'cetakan' kartu panen
                      _buildPanenCard(
                        title: 'Total Hasil Panen Ikan',
                        value: totalPanen['jumlah'].toString(),
                        unit: totalPanen['satuan'],
                        subtitle:
                            'Data Terbaru Bulan : ${totalPanen['periode']}',
                      ),
                      const SizedBox(height: 16),

                      // Panggil 'cetakan' yang sama buat data bibit
                      _buildPanenCard(
                        title: 'Data Bibit Ikan',
                        value: bibitIkan['jumlah'].toString(),
                        unit: bibitIkan['satuan'],
                        subtitle:
                            'Data Terbaru Bulan : ${bibitIkan['periode']}',
                      ),
                      const SizedBox(height: 24),

                      // Judul "Data Hasil Panen POKDAKAN"
                      const Text(
                        'Data Hasil Panen POKDAKAN',
                        style: TextStyle(
                          color: Color(0xFF005A9C),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Panggil 'cetakan' tabel, datanya kita lempar dari 'pokdakan'
                      _buildPanenTable(pokdakan),

                      // Bagian Data Kolam sudah kita hapus ya

                      const SizedBox(height: 32),
                      // Teks footer di paling bawah
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

  // --- WIDGET BANTUAN ---
  // Ini adalah 'cetakan' atau 'fungsi' buat bikin kartu panen.
  // Biar kita ga nulis kode Container-nya berulang-ulang.
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          // 'Align' biar angkanya bisa di pojok kanan
          Align(
            alignment: Alignment.centerRight,
            // 'RichText' biar bisa gabungin 2 style teks (angka gede & 'kg' kecil)
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Text(subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  // Ini 'cetakan' buat bikin tabel POKDAKAN
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
      // 'Table' ini widget bawaan Flutter buat bikin tabel
      child: Table(
        // 'columnWidths' buat ngatur lebar kolomnya
        columnWidths: const {
          0: FlexColumnWidth(2), // Kolom 1 (Batch)
          1: FlexColumnWidth(3), // Kolom 2 (Nama)
          2: FlexColumnWidth(2), // Kolom 3 (Total)
        },
        children: [
          // Ini baris Judul Tabel (Header)
          TableRow(
            decoration: const BoxDecoration(color: Colors.white),
            children: [
              _buildHeaderCell('Batch Panen'),
              _buildHeaderCell('Nama Barang'),
              _buildHeaderCell('Total Berat Batch'),
            ],
          ),
          // 'for' loop ini buat nampilin data barisnya satu per satu
          for (var row in data)
            TableRow(
              decoration: BoxDecoration(
                // Ini buat bikin warna belang-seling (putih-abu)
                color:
                    data.indexOf(row) % 2 == 0 ? Colors.grey[50] : Colors.white,
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

  // Helper kecil buat bikin teks di judul tabel
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

  // Helper kecil buat bikin teks di data tabel
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
