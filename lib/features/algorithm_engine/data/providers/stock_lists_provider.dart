
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/price_shockers_model.dart';
import '../models/stock_lists_model.dart';
import '../models/uni_stock_model.dart';
import '../repository/stock_repository.dart';

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository();
});

final trendingStockProvider =
    FutureProvider<TrendingStockResponse>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchTrendingStocks();
});

final priceShockerProvider =
    FutureProvider<PriceShockerResponse>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchPriceShockers();
});

final bseMostActiveProvider =
    FutureProvider<List<StockModel>>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchBseMostActiveStocks();
});

final nseMostActiveProvider =
    FutureProvider<List<StockModel>>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchNseMostActiveStocks();
});

final week52Provider =
    FutureProvider<Week52Response>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchWeek52Data();
});