import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/keuangan_service.dart';
import 'services/inventaris_service.dart';

class KeuanganPage extends StatefulWidget {
  const KeuanganPage({super.key});

  @override
  State<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage> {
  bool _isLoading = true;
  double _saldo = 0;
  List<dynamic> _transaksiList = [];
  List<dynamic> _inventarisList = []; // [BARU] Variable untuk inventaris

  final KeuanganService _keuanganService = KeuanganService();
  final InventarisService _inventarisService = InventarisService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fungsi ambil data dari API
  Future<void> _fetchData() async {
    try {
      // Panggil kedua API secara bersamaan agar lebih cepat
      final keuanganData = await _keuanganService.getKeuanganData();
      final inventarisData = await _inventarisService.getInventaris(); // [BARU]

      setState(() {
        _saldo = double.parse(keuanganData['saldo'].toString());
        _transaksiList = keuanganData['data'];
        _inventarisList = inventarisData; // [BARU] Simpan data inventaris
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  // Helper Format Rupiah
  String _formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(amount);
  }

  // Helper Format Tanggal (Simple)
  String _formatTanggal(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  child: const Center(child: Icon(Icons.image_not_supported)),
                );
              },
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keuangan',
                    style: TextStyle(
                      color: Color(0xFF005A9C),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card Saldo (Dinamis dari API)
                  _buildDanaCard(
                    title: 'Dana Tambak (Saldo)',
                    amount: _formatRupiah(_saldo),
                    lastTransaction: 'Update Realtime',
                    amountColor: _saldo >= 0 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 16),

                  // Card Transaksi Terakhir (Ambil dari data pertama list)
                  _buildDanaCard(
                    title: 'Transaksi Terakhir',
                    amount: _transaksiList.isNotEmpty
                        ? _formatRupiah(double.parse(_transaksiList[0]['nominal'].toString()))
                        : 'Rp 0',
                    lastTransaction: _transaksiList.isNotEmpty
                        ? 'Pada ${_formatTanggal(_transaksiList[0]['created_at'] ?? DateTime.now().toString())}'
                        : '-',
                    amountColor: Colors.black,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Riwayat Transaksi',
                    style: TextStyle(
                      color: Color(0xFF005A9C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tabel Transaksi (Dinamis)
                  _buildTransaksiTable(),

                  const SizedBox(height: 24),

                  // Note: Inventaris dibiarkan Static dulu karena API Controller Inventaris belum diberikan
                  const Text(
                    'Inventaris Kepemilikan POKDAKAN',
                    style: TextStyle(
                      color: Color(0xFF005A9C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInventarisTable(),

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

  // Cetakan untuk Kartu Dana
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
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 26, // Sedikit diperkecil agar muat
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
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

  // Cetakan untuk Tabel Transaksi (DINAMIS)
  Widget _buildTransaksiTable() {
    if (_transaksiList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: const Center(child: Text("Belum ada data transaksi")),
      );
    }

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
          0: FlexColumnWidth(1),   // No
          1: FlexColumnWidth(3),   // Ket
          2: FlexColumnWidth(2),   // Tgl
          3: FlexColumnWidth(2.5), // Nominal
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            children: [
              _buildHeaderCell('No'),
              _buildHeaderCell('Keterangan'),
              _buildHeaderCell('Tgl'),
              _buildHeaderCell('Nominal'),
            ],
          ),
          // Loop data dari API
          for (var i = 0; i < _transaksiList.length; i++)
            TableRow(
              decoration: BoxDecoration(
                color: i % 2 == 0 ? Colors.grey[50] : Colors.white,
              ),
              children: [
                _buildDataCell((i + 1).toString()), // Nomor urut
                _buildDataCell(_transaksiList[i]['keterangan'] ?? '-'),
                _buildDataCell(_formatTanggal(_transaksiList[i]['created_at'] ?? '')),

                // Cell Nominal dengan warna (Merah = Keluar, Hijau = Masuk)
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _formatRupiah(double.parse(_transaksiList[i]['nominal'].toString())),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _transaksiList[i]['tipe'] == 'Pengeluaran' ? Colors.red : Colors.green
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // --- Tabel Inventaris (Masih Static/Dummy karena controller belum ada) ---
  Widget _buildInventarisTable() {
    if (_inventarisList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: const Center(child: Text("Belum ada data inventaris")),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3), // Nama Barang
            1: FlexColumnWidth(2), // Kondisi
            2: FlexColumnWidth(2), // Pemilik
            3: FlexColumnWidth(1.5), // Jumlah
          },
          children: [
            // Header
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[100]),
              children: [
                _buildHeaderCell('Nama Barang'),
                _buildHeaderCell('Kondisi'), // Pastikan ada kolom ini di DB atau hapus jika tidak ada
                _buildHeaderCell('Pemilik'), // Pastikan ada kolom ini di DB
                _buildHeaderCell('Jml'),
              ],
            ),
            // Data Rows
            for (var i = 0; i < _inventarisList.length; i++)
              TableRow(
                decoration: BoxDecoration(color: i % 2 == 0 ? Colors.white : Colors.grey[50]),
                children: [
                  _buildDataCell(_inventarisList[i]['nama_barang'] ?? '-'),
                  // Sesuaikan key di bawah dengan nama kolom database Anda
                  _buildDataCell(_inventarisList[i]['kondisi'] ?? '-'),
                  _buildDataCell(_inventarisList[i]['pemilik'] ?? '-'),
                  _buildDataCell(_inventarisList[i]['jumlah'].toString()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static TableCell _buildHeaderCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  static TableCell _buildDataCell(String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 12)),
      ),
    );
  }
}