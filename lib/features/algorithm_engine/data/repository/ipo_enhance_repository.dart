// import 'package:flutter/material.dart';
// import '../../../cache_service/data/repository/cache_service.dart';
// import '../../../home/data/repository/ai_repository.dart';
// import '../../../home/data/repository/news_repository.dart';
// import '../models/ipo_model.dart';

// class IpoAiEnrichmentRepository {
//   final CacheService _cache = CacheService();
//   final NewsRepository _newsRepo = NewsRepository();
//   final GeminiRepository _geminiRepo = GeminiRepository();

//   static const _gmpPrefix = 'ipo_ai_';
//   final bool ENABLE_IPO_AI = true;

//   Future<List<IPOModel>> enrichActiveIpos(List<IPOModel> activeIpos) async {
//     final List<IPOModel> result = [];
//     if (!ENABLE_IPO_AI) return [];

//     for (final ipo in activeIpos) {
//       final cacheKey = '$_gmpPrefix${ipo.symbol}';

//       final cached = _cache.get<Map<String, dynamic>>(
//         cacheKey,
//         const Duration(hours: 12),
        
//       );

//       if (cached != null) {
//         result.add(
//           ipo.copyWith(
//             gmp: cached['gmp'],
//             sentiment: cached['sentiment'],
//             confidence: cached['confidence'],
//           ),
//         );
//         continue;
//       }

//       try {
//         debugPrint('🤖 Gemini call for ${ipo.name}');

//         final newsText = await _newsRepo.fetchIpoNewsText(ipo.name);

//         final ai = await _geminiRepo.analyzeIpoGmp(
//           ipoName: ipo.name,
//           newsText: newsText,
//         );

//         debugPrint('🤖 Gemini call for $newsText');
//         debugPrint('📰 News length: ${newsText.length}');
//         debugPrint(newsText.substring(0, newsText.length.clamp(0, 500)));

//         final payload = {
//           'gmp': ai.gmp,
//           'sentiment': ai.sentiment,
//           'confidence': ai.confidence,
//         };

//         _cache.set(cacheKey, payload);
//         result.add(
//           ipo.copyWith(
//             gmp: ai.gmp,
//             sentiment: ai.sentiment,
//             confidence: ai.confidence,
//           ),
//         );
//       } catch (e, st) {
//         debugPrint('❌ AI ERROR for ${ipo.name}');
//         debugPrint(e.toString());
//         debugPrint(st.toString());
//         result.add(ipo);
//       }
//     }

//     return result;
//   }
// }

import 'package:flutter/material.dart';
import '../../../cache_service/data/repository/cache_service.dart';
import '../../../home/data/repository/ai_repository.dart';
import '../../../home/data/repository/news_repository.dart';
import '../models/ipo_model.dart';

class IpoAiEnrichmentRepository {
  final NewsRepository _newsRepo = NewsRepository();
  final GeminiRepository _geminiRepo = GeminiRepository();

  static const _gmpPrefix = 'ipo_ai_';
  static const Duration _ttl = Duration(hours: 12);
  final bool ENABLE_IPO_AI = true;

  Future<List<IPOModel>> enrichActiveIpos(List<IPOModel> activeIpos) async {
    if (!ENABLE_IPO_AI) return activeIpos;

    final List<IPOModel> result = [];

    for (final ipo in activeIpos) {
      final cacheKey = '$_gmpPrefix${ipo.symbol}';

      try {
        // ✅ 1. Read cache (static call, no generics)
        final cached = CacheService.raw(cacheKey);

        if (cached != null && CacheService.isFresh(cacheKey, _ttl)) {
          result.add(
            ipo.copyWith(
              gmp: cached['data']['gmp'],
              sentiment: cached['data']['sentiment'],
              confidence: cached['data']['confidence'],
            ),
          );
          continue;
        }

        debugPrint('🤖 Gemini call for ${ipo.name}');

        // ✅ 2. Fetch news
        final newsText = await _newsRepo.fetchIpoNewsText(ipo.name);

        // ✅ 3. AI analysis
        final ai = await _geminiRepo.analyzeIpoGmp(
          ipoName: ipo.name,
          newsText: newsText,
        );

        final payload = {
          'gmp': ai.gmp,
          'sentiment': ai.sentiment,
          'confidence': ai.confidence,
        };

        // ✅ 4. Save cache (static)
        await CacheService.set(cacheKey, payload);

        result.add(
          ipo.copyWith(
            gmp: ai.gmp,
            sentiment: ai.sentiment,
            confidence: ai.confidence,
          ),
        );
      } catch (e, st) {
        debugPrint('❌ IPO AI ERROR for ${ipo.name}');
        debugPrint(e.toString());
        debugPrint(st.toString());

        // graceful fallback
        result.add(ipo);
      }
    }

    return result;
  }
}
