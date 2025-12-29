// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../../cache_service/data/repository/cache_service.dart';
// import '../models/ipo_model.dart';
// import 'news_repository.dart';
// import 'ai_repository.dart';

// class IpoRepository {
//   final _cache = CacheService();
//   final _newsRepo = NewsRepository();
//   final _geminiRepo = GeminiRepository();

//   static const _ipoListKey = 'ipo_list';
//   static const _ipoGmpPrefix = 'ipo_gmp_';

//   void clearIpoCache() {
//     _cache.invalidate(_ipoListKey);
//     _cache.invalidateByPrefix(_ipoGmpPrefix);
//   }

//   Future<List<Ipo>> fetchTopIpos() async {
//   final cached = _cache.get<List<dynamic>>(
//     _ipoListKey,
//     const Duration(hours: 6),
//   );

//   if (cached != null) {
//     return cached.map((e) {
//       final Map<String, dynamic> normalized =
//           Map<String, dynamic>.from(e as Map);
//       return Ipo.fromJson(normalized);
//     }).toList();
//   }

//   final url = Uri.parse('https://www.nseindia.com/api/ipo-current-issue');

//   final response = await http.get(
//     url,
//     headers: {
//       'User-Agent': 'Mozilla/5.0',
//       'Accept': 'application/json',
//       'Referer': 'https://www.nseindia.com/',
//     },
//   );

//   final dynamic decoded = jsonDecode(response.body);

//   final List<dynamic> list = decoded is List
//       ? decoded
//       : decoded is Map && decoded['data'] is List
//           ? decoded['data']
//           : [];

//   final ipos = list.take(3).map<Ipo>((raw) {
//     final Map item = raw as Map;

//     return Ipo(
//       name: item['companyName']?.toString() ?? 'Unknown',
//       gmp: '—',
//       subscription: item['noOfTime']?.toString() ?? 'N/A',
//       dates:
//           '${item['issueStartDate'] ?? '-'} – ${item['issueEndDate'] ?? '-'}',
//       type: item['series']?.toString() ?? '',
//     );
//   }).toList();

//   _cache.set(
//     _ipoListKey,
//     ipos.map((e) => e.toJson()).toList(),
//   );

//   return ipos;
// }


//   Future<List<Ipo>> enrichIposWithAI(List<Ipo> ipos) async {
//     final List<Ipo> result = [];

//     for (final ipo in ipos) {
//       final cacheKey = 'ipo_gmp_${ipo.name}';

//       final cachedGmp = _cache.get<String>(cacheKey, const Duration(hours: 12));

//       if (cachedGmp != null) {
//         result.add(ipo.copyWith(gmp: cachedGmp));
//         continue;
//       }

//       try {
//         debugPrint('🤖 Gemini call for ${ipo.name}');

//         final newsText = await _newsRepo.fetchIpoNewsText(ipo.name);
//         final ai = await _geminiRepo.analyzeIpoGmp(
//           ipoName: ipo.name,
//           newsText: newsText,
//         );

//         _cache.set(cacheKey, ai.gmp);

//         result.add(ipo.copyWith(gmp: ai.gmp));
//       } catch (e) {
//         result.add(ipo);
//       }
//     }

//     return result;
//   }

// }
