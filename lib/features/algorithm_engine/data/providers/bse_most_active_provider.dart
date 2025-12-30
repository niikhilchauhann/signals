import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/BSE_most_active_model.dart';
import '../repository/stock_repository.dart';

/// Repository Provider
final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository();
});

/// BSE Most Active Stocks Provider
final bseMostActiveProvider =
    FutureProvider<List<StockModel>>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchBseMostActiveStocks();
});
