import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Tambah Import ini
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
    // GANTI MaterialApp JADI GetMaterialApp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mina Jaya App',
      home: FutureBuilder<bool>(
        future: AuthService().isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasData && snapshot.data == true) {
            return const MainPage();
          } else {
            // Hapus const di sini, karena LoginPage sekarang punya controller injeksi
            return LoginPage();
          }
        },
      ),
    );
  }
}