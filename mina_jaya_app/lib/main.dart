import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';
import 'main_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mina Jaya App',
      // Cek status login
      home: FutureBuilder<bool>(
        future: AuthService().isLoggedIn(),
        builder: (context, snapshot) {
          // 1. Tampilan saat Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          // 2. Jika Sudah Login -> Buka MainPage (BUKAN HomePage/Dashboard)
          if (snapshot.hasData && snapshot.data == true) {
            return const MainPage(); // <--- [PERBAIKI DISINI] Jangan 'HomePage()'
          }

          // 3. Jika Belum Login -> Buka LoginPage
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}