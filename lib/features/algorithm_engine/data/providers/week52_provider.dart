import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/week_high_low_data_model.dart';
import '../repository/stock_repository.dart';

/// Repository Provider
final week52RepositoryProvider =
    Provider<StockRepository>((ref) {
  return StockRepository();
});

/// Main Provider
final week52Provider =
    FutureProvider<Week52Response>((ref) async {
  final repo = ref.read(week52RepositoryProvider);
  return repo.fetchWeek52Data();
});
