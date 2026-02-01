import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../features/cache_service/data/repository/cache_service.dart';

final String _apiKey = dotenv.env['INDIANAPI'] ?? '';
const baseUrl = 'https://stock.indianapi.in';

class ApiService {
  ApiService();

  final headers = {
    'X-Api-Key': _apiKey,
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

Future<dynamic> getRequest(String path) async {
  final cacheKey = 'api_$path';

  final cached = CacheService().get<dynamic>(
    cacheKey,
    const Duration(minutes: 5),
  );

  if (cached != null) return cached;

  final response = await http.get(Uri.parse(baseUrl + path));

  if (response.statusCode == 429) {
    debugPrint('⛔ RATE LIMITED: $path');
    if (cached != null) return cached;
    throw Exception('Rate limited');
  }

  final data = _handleResponse(response);
  CacheService().set(cacheKey, data);
  return data;
}


  // Future<dynamic> getRequest(
  //   String endpoint, {
  //   Map<String, String>? query,
  // }) async {
  //   final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
  //   final response = await http.get(uri, headers: headers);
  //   return _handleResponse(response);
  // }

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
