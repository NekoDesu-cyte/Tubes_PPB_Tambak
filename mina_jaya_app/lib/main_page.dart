import 'package:flutter/material.dart';
import 'package:mina_jaya_app/services/auth_service.dart';
import 'dashboard.dart';
import 'keuangan.dart';
import 'statistik.dart';
import 'panen.dart';
import 'notification.dart';
import 'profile_page.dart'; // Pastikan file ini sudah ada

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  String userName = 'Pengguna';

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),      // Pastikan dashboard.dart tidak punya AppBar lagi agar tidak double
    const PanenPage(),
    const StatistikPage(),
    const KeuanganPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final authService = AuthService();
    final userData = await authService.getUserProfile();

    if (userData != null) {
      setState(() {
        userName = userData['name'] ?? 'Pengguna';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Widget helper untuk membuat tombol bulat biru
  Widget _buildTopIcon(IconData icon, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agar background konten (gambar tambak) bisa naik ke belakang AppBar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparan agar menyatu dengan gambar di halaman anak
        elevation: 0,
        title: Text(
          'Selamat Datang, $userName',
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
          // 1. Tombol Notifikasi (Lonceng)
          _buildTopIcon(
            Icons.notifications_none,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),

          // 2. [BARU] Tombol Profil
          _buildTopIcon(
            Icons.person, // Ikon orang/profil
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),

          const SizedBox(width: 16), // Jarak di sebelah kanan
        ],
      ),
      body: Center(
        // Menampilkan halaman sesuai tab yang dipilih
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