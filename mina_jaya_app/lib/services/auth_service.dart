import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // GANTI IP seusai kebutuhanmu gaes:
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // 1. Login
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          String token = data['token'];

          // Simpan token ke HP
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          return true; // Login berhasil
        }
      }

      print('Gagal Login: ${response.body}');
      return false;

    } catch (e) {
      print('Error Koneksi Login: $e');
      return false;
    }
  }

  // 2. Ambil Data Profil User
  Future<Map<String, dynamic>?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('$baseUrl/me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // --- BAGIAN INI SAYA TAMBAHKAN UNTUK CEK ISI DATA ---
      print("=== CEK DATA USER DARI SERVER ===");
      print(response.body); // Ini akan mencetak semua data mentah
      print("===================================");
      // ----------------------------------------------------

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
          return jsonResponse['data'];
        }
        return jsonResponse;
      }
    } catch (e) {
      print("Error Get User: $e");
    }
    return null;
  }

  // 3. Cek Status Login (INI YANG TADI HILANG)
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  // 4. Fungsi log out cuyy
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/logout');

    try {
      await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      // Abaikan error koneksi
    }

    // Hapus token dari memori HP
    await prefs.remove('token');
  }

  // 5. Ambil token (Opsional)
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}