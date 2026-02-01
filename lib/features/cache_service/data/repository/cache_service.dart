// import 'package:hive/hive.dart';

// class CacheService {
//   final Box _box = Hive.box('cache');

//   T? get<T>(String key, Duration ttl) {
//     final entry = _box.get(key);
//     if (entry == null) return null;

//     final timestamp = DateTime.parse(entry['ts']);
//     if (DateTime.now().difference(timestamp) > ttl) {
//       _box.delete(key);
//       return null;
//     }
//     return entry['data'] as T;
//   }

//   void set<T>(String key, T data) {
//     _box.put(key, {
//       'data': data,
//       'ts': DateTime.now().toIso8601String(),
//     });
//   }

//   /// 🔥 NEW
//   void invalidate(String key) {
//     _box.delete(key);
//   }

//   /// 🔥 NEW
//   void invalidateByPrefix(String prefix) {
//     for (final key in _box.keys) {
//       if (key.toString().startsWith(prefix)) {
//         _box.delete(key);
//       }
//     }
//   }
// }

import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const _boxName = 'api_cache';
  static const _tsField = 'ts';
  static const _dataField = 'data';

  static Box<Map>? _box;

  /// Call this once during app init: await CacheService.init();
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Map>(_boxName);
    } else {
      _box = Hive.box<Map>(_boxName);
    }
  }

  static String _key(String name) => 'cache:$name';

  static Future<void> set(String name, dynamic data) async {
    _box ??= Hive.box<Map>(_boxName);
    final payload = {
      _tsField: DateTime.now().millisecondsSinceEpoch,
      _dataField: data,
    };
    await _box!.put(_key(name), payload);
  }

  /// Returns data if available and not deserialized; returns null if not present.
  static dynamic get(String name) {
    _box ??= Hive.box<Map>(_boxName);
    final raw = _box!.get(_key(name));
    if (raw == null) return null;
    return raw[_dataField];
  }

  /// Return cached payload and timestamp map for advanced handling
  static Map<String, dynamic>? raw(String name) {
    _box ??= Hive.box<Map>(_boxName);
    final raw = _box!.get(_key(name));
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw.cast<String, dynamic>());
  }

  static bool isFresh(String name, Duration ttl) {
    final r = raw(name);
    if (r == null) return false;
    final ts = r[_tsField] as int?;
    if (ts == null) return false;
    final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(ts));
    return age <= ttl;
  }

  /// Return cached data even if stale (or null)
  static dynamic getAny(String name) => get(name);

  static Future<void> clear(String name) async {
    _box ??= Hive.box<Map>(_boxName);
    await _box!.delete(_key(name));
  }

  static Future<void> clearAll() async {
    _box ??= Hive.box<Map>(_boxName);
    await _box!.clear();
  }
}
