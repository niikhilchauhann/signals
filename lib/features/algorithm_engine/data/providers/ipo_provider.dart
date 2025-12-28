import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/ipo_model.dart';
import '../repository/stock_repository.dart';

final ipoRepositoryProvider = Provider((ref) => StockRepository());

final ipoProvider = FutureProvider<IpoList>((ref) async {
  return ref.read(ipoRepositoryProvider).fetchAllIpos();
});

final ipoFilterProvider = StateProvider<String>((ref) => 'upcoming');
final searchProvider = StateProvider<String>((ref) => '');
final sortProvider = StateProvider<bool>((ref) => true); // true = latest first
