import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'watchlist_repository.dart';

final watchlistRepositoryProvider = Provider((ref) => WatchlistRepository());

class WatchlistNotifier extends StateNotifier<List<String>> {
  final WatchlistRepository repo;
  WatchlistNotifier(this.repo) : super(repo.getAll());

  Future<void> reload() async {
    state = repo.getAll();
  }

  Future<void> add(String symbol) async {
    await repo.add(symbol);
    state = repo.getAll();
  }

  Future<void> remove(String symbol) async {
    await repo.remove(symbol);
    state = repo.getAll();
  }

  bool contains(String symbol) => state.contains(symbol);
}

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, List<String>>((ref) {
  final repo = ref.read(watchlistRepositoryProvider);
  return WatchlistNotifier(repo);
});
