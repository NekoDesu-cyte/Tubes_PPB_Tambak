import 'package:flutter/material.dart';
import 'package:mina_jaya_app/services/auth_service.dart';
import 'dashboard.dart';
import 'keuangan.dart';
import 'statistik.dart';
import 'notification.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  String userName = 'Pengguna';
  String userRole = 'user';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final authService = AuthService();
    final userData = await authService.getUserProfile();

    if (userData != null) {
      setState(() {
        userName = userData['name'] ?? 'Pengguna';
        userRole = userData['role'] ?? 'user';
        _selectedIndex = 0; // reset aman
      });
    }
  }

  /// =========================
  /// NAVIGATION CONFIG (SINGLE SOURCE OF TRUTH)
  /// =========================
  List<_NavItem> get _navItems {
    if (userRole == 'admin') {
      return [
        _NavItem(label: 'Home', icon: Icons.home, page: const HomePage()),
        _NavItem(
          label: 'Statistik',
          icon: Icons.query_stats,
          page: const StatistikPage(),
        ),
        _NavItem(
          label: 'Keuangan',
          icon: Icons.account_balance_wallet_outlined,
          page: const KeuanganPage(),
        ),
      ];
    }

    // USER BIASA (TANPA KEUANGAN)
    return [
      _NavItem(label: 'Home', icon: Icons.home, page: const HomePage()),
      _NavItem(
        label: 'Statistik',
        icon: Icons.query_stats,
        page: const StatistikPage(),
      ),
    ];
  }

  void _onItemTapped(int index) {
    if (index >= _navItems.length) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTopIcon(IconData icon, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue[700],
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _navItems;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Selamat Datang, $userName',
          style: const TextStyle(
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
        actions: [
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
          _buildTopIcon(
            Icons.person,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),

      /// BODY
      body: navItems.isEmpty ? const SizedBox() : navItems[_selectedIndex].page,

      /// BOTTOM NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        items: navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromRGBO(56, 137, 213, 1),
        selectedItemColor: const Color.fromARGB(255, 130, 210, 244),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        elevation: 8,
      ),
    );
  }
}

/// =========================
/// HELPER CLASS
/// =========================
class _NavItem {
  final String label;
  final IconData icon;
  final Widget page;

  _NavItem({required this.label, required this.icon, required this.page});
}
