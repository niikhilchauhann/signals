import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trending_model.dart';
import '../repository/stock_repository.dart';

/// Repository Provider
final trendingStockRepositoryProvider =
    Provider<StockRepository>((ref) {
  return StockRepository();
});

/// Trending Stocks Provider
final trendingStockProvider =
    FutureProvider<TrendingStockResponse>((ref) async {
  final repo = ref.read(trendingStockRepositoryProvider);
  return repo.fetchTrendingStocks();
});
