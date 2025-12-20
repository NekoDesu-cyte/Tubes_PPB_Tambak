import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventarisService {
  // GANTI IP: Gunakan 10.0.2.2 untuk Emulator, atau IP Laptop untuk HP Fisik
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getInventaris() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/inventaris');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // Sesuai controller: return response()->json(['data' => $data])
        return jsonResponse['data'];
      } else {
        throw Exception('Gagal memuat inventaris: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }
}