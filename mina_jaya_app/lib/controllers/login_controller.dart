import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../main_page.dart'; // Pastikan import ini benar ke MainPage kamu

class LoginController extends GetxController {
  // 1. Variable State (Pengganti isLoading di UI)
  // .obs artinya "Observable" (Bisa dipantau perubahannya secara real-time)
  var isLoading = false.obs;

  // 2. Controller Inputan (Pindah ke sini biar UI bersih)
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Instance Service
  final AuthService _authService = AuthService();

  // 3. Fungsi Login
  Future<void> login() async {
    // Validasi sederhana
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
          "Error",
          "Email dan Password harus diisi",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );
      return;
    }

    // Mulai Loading
    isLoading.value = true;

    // Panggil Service (Proses ke Laravel)
    bool success = await _authService.login(
        emailController.text,
        passwordController.text
    );

    // Selesai Loading
    isLoading.value = false;

    // Cek Hasil
    if (success) {
      Get.snackbar(
          "Sukses",
          "Login Berhasil!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );

      // Pindah Halaman & Hapus history login (biar gak bisa di-back)
      Get.offAll(() => const MainPage());
    } else {
      Get.snackbar(
          "Gagal",
          "Email atau Password Salah.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM
      );
    }
  }

  @override
  void onClose() {
    // Bersihkan memori saat controller tidak dipakai
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}