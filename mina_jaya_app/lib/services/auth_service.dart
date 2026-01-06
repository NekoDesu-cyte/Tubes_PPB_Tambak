import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // GANTI IP seusai konfigurasi komputer/emulator Anda:
  // Emulator Android: 10.0.2.2
  // HP Fisik (Debugging USB): Gunakan IP Laptop (misal 192.168.1.x)
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // 1. Login
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          String token = data['token'];

          // Simpan token ke memori HP
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

      // Debugging: Cek data mentah dari server
      // print("=== DATA USER ===");
      // print(response.body);

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        // Laravel biasanya membungkus data dalam key 'data'
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('data')) {
          return jsonResponse['data'];
        }
        return jsonResponse;
      }
    } catch (e) {
      print("Error Get User: $e");
    }
    return null;
  }

  // 3. Cek Status Login (Apakah token ada?)
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  // 4. Logout
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
      // Abaikan error jika koneksi putus saat logout, tetap hapus token lokal
      print("Logout Error (Ignored): $e");
    }

    // Hapus token dari memori HP agar user keluar
    await prefs.remove('token');
  }

  // 5. Ambil token (Opsional, jika butuh di controller lain)
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 6. Update Profil (Fitur Baru)
  Future<bool> updateProfile(Map<String, String> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/profile');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json', // Wajib agar Laravel membalas JSON
          'Authorization': 'Bearer $token',
        },
        body: data,
      );

      // Debugging Response
      print("Update Profile Status: ${response.statusCode}");
      print("Update Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        return true; // Berhasil
      } else {
        // Jika validasi gagal (misal email kembar)
        print("Gagal Update Profil: ${response.body}");
      }
    } catch (e) {
      print("Error Update Profile: $e");
    }
    return false;
  }
}
