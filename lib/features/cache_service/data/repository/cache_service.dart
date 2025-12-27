import 'package:hive/hive.dart';

class CacheService {
  final Box _box = Hive.box('cache');

  T? get<T>(String key, Duration ttl) {
    final entry = _box.get(key);
    if (entry == null) return null;

    final timestamp = DateTime.parse(entry['ts']);
    if (DateTime.now().difference(timestamp) > ttl) {
      _box.delete(key);
      return null;
    }
    return entry['data'] as T;
  }

  void set<T>(String key, T data) {
    _box.put(key, {
      'data': data,
      'ts': DateTime.now().toIso8601String(),
    });
  }

  /// 🔥 NEW
  void invalidate(String key) {
    _box.delete(key);
  }

  /// 🔥 NEW
  void invalidateByPrefix(String prefix) {
    for (final key in _box.keys) {
      if (key.toString().startsWith(prefix)) {
        _box.delete(key);
      }
    }
  }
}
