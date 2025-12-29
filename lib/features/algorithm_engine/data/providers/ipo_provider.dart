import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/ipo_model.dart';
import '../repository/ipo_enhance_repository.dart';
import '../repository/stock_repository.dart';

final ipoRepositoryProvider = Provider((ref) => StockRepository());

final ipoProvider = FutureProvider<IpoList>((ref) async {
  return ref.read(ipoRepositoryProvider).fetchAllIpos();
});

final ipoFilterProvider = StateProvider<String>((ref) => 'upcoming');
final searchProvider = StateProvider<String>((ref) => '');
final sortProvider = StateProvider<bool>((ref) => true); // true = latest first


final activeIposProvider = Provider<List<IPOModel>>((ref) {
  final ipoAsync = ref.watch(ipoProvider);

  return ipoAsync.maybeWhen(
    data: (list) => list.active,
    orElse: () => [],
  );
});

final ipoAiEnrichmentRepositoryProvider =
    Provider((ref) => IpoAiEnrichmentRepository());

final enrichedActiveIposProvider =
    FutureProvider<List<IPOModel>>((ref) async {
  final activeIpos = ref.watch(activeIposProvider);

  if (activeIpos.isEmpty) return [];

  final repo = ref.read(ipoAiEnrichmentRepositoryProvider);
  return repo.enrichActiveIpos(activeIpos);
});
