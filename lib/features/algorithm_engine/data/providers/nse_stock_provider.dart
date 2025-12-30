import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/NSE_most_active_model.dart';
import '../repository/stock_repository.dart';

/// Repository Provider
final nseStockRepositoryProvider =
    Provider<StockRepository>((ref) {
  return StockRepository();
});

/// NSE Stock List Provider
final nseStockProvider =
    FutureProvider<List<NseStockModel>>((ref) async {
  final repo = ref.read(nseStockRepositoryProvider);
  return repo.fetchNseStocks();
});
