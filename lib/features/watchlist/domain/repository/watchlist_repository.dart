import 'package:hive_flutter/hive_flutter.dart';

class WatchlistRepository {
  static const _boxName = 'watchlist_box';
  static const _key = 'symbols';

  final Box<List> _box = Hive.box<List>(_boxName);

  List<String> getAll() {
    final raw = _box.get(_key);
    if (raw == null) return [];
    return List<String>.from(raw);
  }

  Future<void> add(String symbol) async {
    final current = getAll();
    if (!current.contains(symbol)) {
      final updated = [...current, symbol];
      await _box.put(_key, updated);
    }
  }

  Future<void> remove(String symbol) async {
    final current = getAll();
    final updated = current.where((s) => s != symbol).toList();
    await _box.put(_key, updated);
  }

  Future<void> clear() async {
    await _box.delete(_key);
  }
}
