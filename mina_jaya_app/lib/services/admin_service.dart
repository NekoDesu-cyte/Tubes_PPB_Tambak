import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // 1. Ambil Semua User
  Future<List<dynamic>> getAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/admin/users');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Kembalikan List User
      }
    } catch (e) {
      print("Error Admin Users: $e");
    }
    return [];
  }

  // 2. Ubah Role User
  Future<bool> updateUserRole(int userId, String newRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/admin/users/$userId/role');

    try {
      final response = await http.post(
          url,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: {
            'role': newRole,
          }
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error Update Role: $e");
      return false;
    }
  }
}