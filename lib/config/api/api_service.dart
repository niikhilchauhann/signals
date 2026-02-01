// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import '../../features/cache_service/data/repository/cache_service.dart';

// final String _apiKey = dotenv.env['INDIANAPI'] ?? '';
// const baseUrl = 'https://stock.indianapi.in';

// class ApiService {
//   ApiService();

//   final headers = {
//     'X-Api-Key': _apiKey,
//     'Accept': 'application/json',
//     'Content-Type': 'application/json',
//   };

// Future<dynamic> getRequest(String path) async {
//   final cacheKey = 'api_$path';

//   final cached = CacheService().get<dynamic>(
//     cacheKey,
//     const Duration(minutes: 5),
//   );

//   if (cached != null) return cached;

//   final response = await http.get(Uri.parse(baseUrl + path));

//   if (response.statusCode == 429) {
//     debugPrint('⛔ RATE LIMITED: $path');
//     if (cached != null) return cached;
//     throw Exception('Rate limited');
//   }

//   final data = _handleResponse(response);
//   CacheService().set(cacheKey, data);
//   return data;
// }


//   // Future<dynamic> getRequest(
//   //   String endpoint, {
//   //   Map<String, String>? query,
//   // }) async {
//   //   final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: query);
//   //   final response = await http.get(uri, headers: headers);
//   //   return _handleResponse(response);
//   // }

//   Future<dynamic> postRequest(
//     String endpoint,
//     Map<String, dynamic> data,
//   ) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: headers,
//       body: jsonEncode(data),
//     );
//     return _handleResponse(response);
//   }

//   Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: headers,
//       body: jsonEncode(data),
//     );
//     return _handleResponse(response);
//   }

//   dynamic _handleResponse(http.Response response) {
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load data: ${response.statusCode}');
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../features/cache_service/data/repository/cache_service.dart';

final String _apiKey = dotenv.env['INDIANAPI'] ?? '';
const baseUrl = 'https://stock.indianapi.in';


class ApiService {
  // baseUrl should be as in your project. Keep existing constructor etc.
  final String baseUrl;

  ApiService({this.baseUrl = 'https://stock.indianapi.in'}) ; // example


  Map<String, String> get _headers => {
        'X-Api-Key': _apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };


  /// ttl: how long the cached result stays valid. If null, no caching.
  /// forceRefresh: bypass cache and fetch remote.
  Future<dynamic> getRequest(String path, {Duration? ttl, bool forceRefresh = false}) async {
    final cacheKey = path; // keep simple
    try {
      // 1) serve cache if present and fresh (unless forceRefresh)
      if (!forceRefresh && ttl != null) {
        final cached = CacheService.getAny(cacheKey);
        if (cached != null && CacheService.isFresh(cacheKey, ttl)) {
          debugPrint('🗄️ ApiService: serving cached $path');
          return cached;
        }
      } else if (!forceRefresh && ttl == null) {
        // if no ttl specified, still try returning cached value (fallback) in errors
        final cached = CacheService.getAny(cacheKey);
        if (cached != null) {
          debugPrint('🗄️ ApiService: returning cached(no-ttl) for $path');
          // don't return here automatically; try network first below.
        }
      }

      // 2) fetch remote
      final url = Uri.parse('$baseUrl$path');
      final response = await http.get(url, headers: _headers);

      // handle non-2xx
      if (response.statusCode != 200) {
        debugPrint('⚠️ ApiService: $path returned ${response.statusCode}');
        // if rate limit or other error, fallback to any cached data if available
        final cached = CacheService.getAny(cacheKey);
        if (cached != null) {
          debugPrint('🗄️ ApiService: using stale cache for $path due to remote error');
          return cached;
        }
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      // save to cache if ttl provided
      if (ttl != null) {
        await CacheService.set(cacheKey, decoded);
      }

      return decoded;
    } catch (e) {
      debugPrint('🛑 ApiService exception for $path: $e');
      // fallback to cached data if available
      final cached = CacheService.getAny(cacheKey);
      if (cached != null) {
        debugPrint('🗄️ ApiService: fallback to cache for $path after exception');
        return cached;
      }
      rethrow;
    }
  }

  /// Optional helper to clear single endpoint cache
  Future<void> clearCache(String path) async {
    await CacheService.clear(path);
  }

  Future<void> clearAllCache() async {
    await CacheService.clearAll();
  }
}
