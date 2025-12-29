import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/market_overview.dart';
import '../data/models/trade_model.dart';
import '../data/repository/ipo_repository.dart';
import '../data/repository/market_repository.dart';
import '../data/repository/trade_repository.dart';

final marketRepositoryProvider = Provider(
  (ref) => MarketRepository(),
);

// final ipoRepositoryProvider = Provider(
//   (ref) => IpoRepository(),
// );

final tradeRepositoryProvider = Provider(
  (ref) => TradeRepository(),
);


final marketOverviewProvider = FutureProvider<MarketOverview>((ref) {
  return ref.read(marketRepositoryProvider).fetchMarketOverview();
});

// final topIposProvider = FutureProvider<List<Ipo>>((ref) {
//   return ref.read(ipoRepositoryProvider).fetchTopIpos();
// });

final topTradesProvider = FutureProvider<List<TradeSetup>>((ref) {
  return ref.read(tradeRepositoryProvider).fetchTopTrades();
});


// final ipoWithGmpProvider = FutureProvider<List<Ipo>>((ref) async {
//   final repo = ref.read(ipoRepositoryProvider);
//   final baseIpos = await repo.fetchTopIpos();
//   return repo.enrichIposWithAI(baseIpos);
// });


final ipoRefreshProvider = Provider<void Function()>((ref) {
  return () {
    // final repo = ref.read(ipoRepositoryProvider);

    // 1️⃣ Clear cache
    // repo.clearIpoCache();

    // 2️⃣ Force providers to refetch
    // ref.invalidate(topIposProvider);
    // ref.invalidate(ipoWithGmpProvider);
  };
});
