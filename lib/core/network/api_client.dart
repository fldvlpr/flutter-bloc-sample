import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final _baseUrl = 'https://dummyjson.com';

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to GET data from $endpoint');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      body: jsonEncode(body),
      headers: {'Content-type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to POST data to $endpoint');
    }
  }
}
