import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/price_shockers_model.dart';
import '../repository/stock_repository.dart';

/// Repository Provider
final PriceShockerRepositoryProvider =
    Provider<StockRepository>((ref) {
  return StockRepository();
});

/// API Provider
final priceShockerProvider =
    FutureProvider<BsePriceShockerResponse>((ref) async {
  final repo = ref.read(PriceShockerRepositoryProvider);
  return repo.fetchBsePriceShockers();
});
