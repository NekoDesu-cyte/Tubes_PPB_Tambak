import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  // GANTI IP SESUAI CONFIG ANDA (10.0.2.2 untuk Emulator)
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>?> getDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/dashboard');

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
        // Kita ambil isi 'data'-nya saja (yang berisi 'sensor' dan 'pie_chart')
        if (data['success'] == true) {
          return data['data'];
        }
      }
    } catch (e) {
      print("Error Dashboard: $e");
    }
    return null;
  }
}