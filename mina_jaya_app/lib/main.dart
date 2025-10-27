import 'package:flutter/material.dart';
import 'dashboard.dart'; // Changed from home_page.dart
import 'keuangan.dart'; // Changed from keuangan_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(), // Added const
    );
  }
}

// --- WIDGET BARU UNTUK MENGATUR NAVIGASI ---
// Kita ubah ini jadi StatefulWidget
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Indeks halaman yang sedang aktif. 2 = Home
  int _selectedIndex = 2;

  // Daftar semua halaman utama kita
  final List<Widget> _widgetOptions = <Widget>[
    const Center(child: Text('Halaman Statistik')), // (Placeholder untuk indeks 0)
    const Center(child: Text('Halaman Pakan')), // (Placeholder untuk indeks 1)
    const HomePage(), // Halaman Home (indeks 2)
    const KeuanganPage(), // Halaman Keuangan (indeks 3)
    const Center(child: Text('Halaman Stok')), // (Placeholder untuk indeks 4)
  ];

  // Fungsi yang dipanggil saat item navbar diklik
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan otomatis berganti sesuai halaman yang dipilih
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // Bottom Navigation Bar
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            // Ganti ikonnya agar sesuai
            icon: Icon(Icons.account_balance_wallet_outlined), // <- Ganti ikon
            label: 'Keuangan', // <- Ganti label
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromRGBO(56, 137, 213, 1),
        selectedItemColor: const Color.fromARGB(255, 130, 210, 244),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true, // Tampilkan semua label
        showSelectedLabels: true,
        elevation: 8.0,
      ),
    );
  }
}