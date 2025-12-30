import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_model.dart';
import '../repository/stock_repository.dart';

/// Repository Provider
final newsRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository();
});

/// News List Provider
final newsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  final repo = ref.read(newsRepositoryProvider);
  return repo.fetchNews();
});
