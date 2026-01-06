import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'controllers/login_controller.dart'; // Import Controller yang baru dibuat

// UBAH JADI STATELESS WIDGET (Karena state sudah diurus Controller)
class LoginPage extends StatelessWidget {
  // Suntikkan (Inject) Controller ke halaman ini
  final LoginController controller = Get.put(LoginController());

  // Hapus 'const' karena ada Get.put() di atas
  LoginPage({super.key});

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

              // Logo & Judul (Sama seperti sebelumnya)
              Image.asset(
                'assets/logo_tambak.jpg',
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tambak Mina Jaya',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              // INPUT EMAIL
              TextField(
                controller:
                    controller.emailController, // Pakai punya Controller
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // INPUT PASSWORD
              TextField(
                controller:
                    controller.passwordController, // Pakai punya Controller
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // TOMBOL LOGIN (Dengan Obx)
              // Obx berguna agar tombol ini bereaksi saat isLoading berubah
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null // Jika loading, tombol mati
                        : () => controller
                              .login(), // Panggil fungsi di controller
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
