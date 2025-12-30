import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/commodities_model.dart';
import '../repository/stock_repository.dart';

/// Repository Provider
final commodityRepositoryProvider =
    Provider<StockRepository>((ref) {
  return StockRepository();
});

/// Commodity Data Provider
final commodityListProvider =
    FutureProvider<List<CommodityModel>>((ref) async {
  final repo = ref.read(commodityRepositoryProvider);
  return repo.fetchCommodities();
});
