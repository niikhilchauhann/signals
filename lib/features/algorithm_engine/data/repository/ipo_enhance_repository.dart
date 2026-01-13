import 'package:flutter/material.dart';
import '../../../cache_service/data/repository/cache_service.dart';
import '../../../home/data/repository/ai_repository.dart';
import '../../../home/data/repository/news_repository.dart';
import '../models/ipo_model.dart';

class IpoAiEnrichmentRepository {
  final CacheService _cache = CacheService();
  final NewsRepository _newsRepo = NewsRepository();
  final GeminiRepository _geminiRepo = GeminiRepository();

  static const _gmpPrefix = 'ipo_ai_';
  final bool ENABLE_IPO_AI = false;

  Future<List<IPOModel>> enrichActiveIpos(List<IPOModel> activeIpos) async {
    final List<IPOModel> result = [];
    if (!ENABLE_IPO_AI) return [];

    for (final ipo in activeIpos) {
      final cacheKey = '$_gmpPrefix${ipo.symbol}';

      final cached = _cache.get<Map<String, dynamic>>(
        cacheKey,
        const Duration(hours: 12),
      );

      if (cached != null) {
        result.add(
          ipo.copyWith(
            gmp: cached['gmp'],
            sentiment: cached['sentiment'],
            confidence: cached['confidence'],
          ),
        );
        continue;
      }

      try {
        debugPrint('🤖 Gemini call for ${ipo.name}');

        final newsText = await _newsRepo.fetchIpoNewsText(ipo.name);

        final ai = await _geminiRepo.analyzeIpoGmp(
          ipoName: ipo.name,
          newsText: newsText,
        );

        debugPrint('🤖 Gemini call for $newsText');
        debugPrint('📰 News length: ${newsText.length}');
        debugPrint(newsText.substring(0, newsText.length.clamp(0, 500)));

        final payload = {
          'gmp': ai.gmp,
          'sentiment': ai.sentiment,
          'confidence': ai.confidence,
        };

        _cache.set(cacheKey, payload);
        if (ENABLE_IPO_AI) {
          result.add(
            ipo.copyWith(
              gmp: ai.gmp,
              sentiment: ai.sentiment,
              confidence: ai.confidence,
            ),
          );
        }
      } catch (e, st) {
        debugPrint('❌ AI ERROR for ${ipo.name}');
        debugPrint(e.toString());
        debugPrint(st.toString());
        result.add(ipo);
      }
    }

    return result;
  }
}
