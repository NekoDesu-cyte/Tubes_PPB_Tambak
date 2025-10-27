import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variabel state untuk menyimpan status checkbox
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Background utama diubah menjadi putih
      backgroundColor: Colors.white,
      // 2. SafeArea agar konten tidak mentok di status bar (atas)
      body: SafeArea(
        // 3. Layout bisa di-scroll saat keyboard muncul
        child: SingleChildScrollView(
          // 4. Padding untuk memberi jarak form dari tepi layar
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // CrossAxisAlignment.center adalah default,
            // jadi logo dan judul akan otomatis di tengah
            children: [
              // Beri jarak dari atas layar
              const SizedBox(height: 40),

            // ini bagaian LOGO
              Image.asset(
                'assets/logo_tambak.jpg',
                height: 80,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 16),
              const Text(
                'Tambak Mina Jaya',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Pastikan teks terlihat di bg putih
                ),
              ),
              const SizedBox(height: 32),

              // --- Form Dimulai ---

              // Label "Login"
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Label "Username"
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter Username',
                  filled: true,
                  fillColor: Colors.grey[100], // Warna background field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none, // Hilangkan border
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Label "Password"
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true, // Menyembunyikan teks password
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol "Masuk"
              SizedBox(
                width: double.infinity, // Buat tombol jadi full-width
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to HomePage when login button is pressed
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700], // Warna tombol
                    foregroundColor: Colors.white, // Warna teks tombol
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Masuk'),
                ),
              ),
              const SizedBox(height: 16),

              // Baris untuk "Remember me" dan "Forgot Password?"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bagian "Remember me" (Checkbox + Teks)
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          // Update state saat checkbox diklik
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Remember me',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  // Bagian "Forgot Password?"
                  TextButton(
                    onPressed: () {
                      // TODO: Tambahkan logika lupa password
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}