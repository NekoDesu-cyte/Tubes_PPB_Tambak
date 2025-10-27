import 'package:flutter/material.dart';

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita gunakan Scaffold lagi, tapi tanpa AppBar
    // karena desainnya menyatu dengan gambar atas
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GAMBAR BANNER (FULL-WIDTH) ---
            // Menggunakan gambar yang sama dengan di Home
            Image.asset(
              'assets/images/tambak_banner.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'Gagal memuat gambar',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                );
              },
            ),

            // --- KONTEN UTAMA ---
            // Kita bungkus semua konten di bawah gambar dengan Padding
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul "Keuangan"
                  const Text(
                    'Keuangan',
                    style: TextStyle(
                      color: Color(0xFF005A9C), // Biru tua
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- KARTU DANA TAMBAK ---
                  _buildDanaCard(
                    title: 'Dana Tambak',
                    amount: 'Rp. 12.000.000',
                    lastTransaction: 'Transaksi Terakhir pada 12/09/2025',
                    amountColor: Colors.black, // Warna hitam untuk dana utama
                  ),
                  const SizedBox(height: 16),

                  // --- KARTU TRANSAKSI TERAKHIR ---
                  _buildDanaCard(
                    title: 'Transaksi Terakhir',
                    amount: 'Rp. 920.000',
                    lastTransaction: 'Transaksi Terakhir pada 12/09/2025',
                    amountColor: Colors.red, // Warna merah sesuai desain
                  ),
                  const SizedBox(height: 24),

                  // --- JUDUL TABEL TRANSAKSI ---
                  const Text(
                    'Transaksi Keuangan Tambak',
                    style: TextStyle(
                      color: Color(0xFF005A9C), // Biru tua
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- TABEL TRANSAKSI ---
                  _buildTransaksiTable(),

                  const SizedBox(height: 32),
                  // --- FOOTER TEXT ---
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

  // Widget bantuan untuk kartu Dana
  Widget _buildDanaCard({
    required String title,
    required String amount,
    required String lastTransaction,
    required Color amountColor,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: amountColor, // Warna dinamis
            ),
          ),
          const SizedBox(height: 12),
          Text(
            lastTransaction,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget bantuan untuk membangun tabel
  Widget _buildTransaksiTable() {
    // Data dummy untuk tabel
    final List<Map<String, String>> transactions = [
      {
        "Nomor": "T928B",
        "Nama Transaksi": "Pembelian Pakan...",
        "Tanggal": "11/09/25",
        "Tipe": "Keluar",
      },
      {
        "Nomor": "T928B",
        "Nama Transaksi": "Pembelian Pakan...",
        "Tanggal": "11/09/25",
        "Tipe": "Keluar",
      },
      {
        "Nomor": "T928B",
        "Nama Transaksi": "Pembelian Pakan...",
        "Tanggal": "11/09/25",
        "Tipe": "Keluar",
      },
      {
        "Nomor": "T928B",
        "Nama Transaksi": "Pembelian Pakan...",
        "Tanggal": "11/09/25",
        "Tipe": "Keluar",
      },
      {
        "Nomor": "T928B",
        "Nama Transaksi": "Pembelian Pakan...",
        "Tanggal": "11/09/25",
        "Tipe": "Keluar",
      },
      {
        "Nomor": "T928B",
        "Nama Transaksi": "Pembelian Pakan...",
        "Tanggal": "11/09/25",
        "Tipe": "Keluar",
      },
    ];

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
      // Kita gunakan widget Table untuk layout yang rapi
      child: Table(
        // Lebar kolom
        columnWidths: const {
          0: FlexColumnWidth(1.5), // Nomor
          1: FlexColumnWidth(3), // Nama Transaksi
          2: FlexColumnWidth(2), // Tanggal
          3: FlexColumnWidth(1.5), // Tipe
        },
        children: [
          // --- BARIS HEADER ---
          TableRow(
            decoration: const BoxDecoration(
              color: Colors.white, // Latar belakang header
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            children: [
              _buildHeaderCell('Nomor'),
              _buildHeaderCell('Nama Transaksi'),
              _buildHeaderCell('Tanggal'),
              _buildHeaderCell('Tipe'),
            ],
          ),

          // --- BARIS DATA ---
          // Kita loop data dummy
          for (var tx in transactions)
            TableRow(
              decoration: BoxDecoration(
                // Warna belang-seling (Zebra)
                color: transactions.indexOf(tx) % 2 == 0
                    ? Colors.grey[50]
                    : Colors.white,
              ),
              children: [
                _buildDataCell(tx['Nomor']!),
                _buildDataCell(tx['Nama Transaksi']!),
                _buildDataCell(tx['Tanggal']!),
                _buildDataCell(tx['Tipe']!),
              ],
            ),
        ],
      ),
    );
  }

  // Helper untuk sel header tabel
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

  // Helper untuk sel data tabel
  static TableCell _buildDataCell(String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black87, fontSize: 13),
        ),
      ),
    );
  }
}
