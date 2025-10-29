import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'keuangan.dart';
import 'statistik.dart';
import 'panen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Pastikan nama class-nya benar: HomePage, PanenPage, dst.
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const PanenPage(),
    const StatistikPage(),
    const KeuanganPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- WIDGET BANTUAN UNTUK IKON APPBAR (PINDAHAN DARI HOME) ---
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
  // -----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- TAMBAHKAN KODE APPBAR DI SINI ---
      extendBodyBehindAppBar: true, // <-- BARU
      appBar: AppBar( // <-- BARU
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Selamat Datang, Hafizh',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black54,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        titleSpacing: 16.0,
        actions: [
          _buildTopIcon(Icons.mail_outline),
          _buildTopIcon(Icons.notifications_none),
          _buildTopIcon(Icons.person_outline),
          const SizedBox(width: 16),
        ],
      ),
      // -------------------------------------

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal_outlined),
            label: 'Panen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: 'Statistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Keuangan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromRGBO(56, 137, 213, 1),
        selectedItemColor: const Color.fromARGB(255, 130, 210, 244),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        elevation: 8.0,
      ),
    );
  }
}