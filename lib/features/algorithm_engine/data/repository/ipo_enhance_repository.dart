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

  Future<List<IPOModel>> enrichActiveIpos(List<IPOModel> activeIpos) async {
    final List<IPOModel> result = [];

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

        final newsText =
            await _newsRepo.fetchIpoNewsText(ipo.name);

        final ai = await _geminiRepo.analyzeIpoGmp(
          ipoName: ipo.name,
          newsText: newsText,
        );

        final payload = {
          'gmp': ai.gmp,
          'sentiment': ai.sentiment,
          'confidence': ai.confidence,
        };

        _cache.set(cacheKey, payload);

        result.add(
          ipo.copyWith(
            gmp: ai.gmp,
            sentiment: ai.sentiment,
            confidence: ai.confidence,
          ),
        );
      } catch (e) {
        // graceful fallback
        result.add(ipo);
      }
    }

    return result;
  }
}
