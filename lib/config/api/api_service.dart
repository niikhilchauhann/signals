import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String _apiKey = dotenv.env['INDIANAPI'] ?? '';
const baseUrl = 'https://stock.indianapi.in';

class ApiService {
  ApiService();

  final headers = {
    'X-Api-Key': _apiKey,
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<dynamic> getRequest(
    String endpoint, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
    final response = await http.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> postRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
