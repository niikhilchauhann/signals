import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mutual_funds_model.dart';
import '../repository/stock_repository.dart';

/// Repository Provider
final mutualFundRepositoryProvider =
    Provider<StockRepository>((ref) {
  return StockRepository();
});

/// Mutual Fund Data Provider
final mutualFundProvider =
    FutureProvider<MutualFundResponse>((ref) async {
  final repo = ref.read(mutualFundRepositoryProvider);
  return repo.fetchMutualFunds();
});
