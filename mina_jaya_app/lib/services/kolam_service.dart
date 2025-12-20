import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KolamService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getKolam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/kolam');

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
        return jsonResponse['data'];
      } else {
        throw Exception('Gagal memuat data kolam');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }
}