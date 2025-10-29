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
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

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
                  color: Colors.black, 
                ),
              ),
              const SizedBox(height: 32),

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
                  fillColor: Colors.grey[100], 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true, 
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

              // Masuk Button
              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed: () {
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
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
                  TextButton(
                    onPressed: () {
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