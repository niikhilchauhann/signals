import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/commodities_model.dart';
import '../models/ipo_model.dart';
import '../models/mutual_funds_model.dart';
import '../models/news_model.dart';
import '../repository/ipo_enhance_repository.dart';
import 'stock_lists_provider.dart';

final ipoProvider = FutureProvider<IpoList>((ref) async {
  return ref.read(stockRepositoryProvider).fetchAllIpos();
});

final ipoFilterProvider = StateProvider<String>((ref) => 'upcoming');
final searchProvider = StateProvider<String>((ref) => '');
final sortProvider = StateProvider<bool>((ref) => true); 

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

final newsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchNews();
});

final commodityListProvider =
    FutureProvider<List<CommodityModel>>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchCommodities();
});

final mutualFundProvider =
    FutureProvider<MutualFundResponse>((ref) async {
  final repo = ref.read(stockRepositoryProvider);
  return repo.fetchMutualFunds();
});