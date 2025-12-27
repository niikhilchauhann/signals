import 'package:cupcake/config/api/api_service.dart';

import '../../../home/data/models/indian_market_model.dart';

class IndianMarketRepository {
  final _client = ApiService();

  List<dynamic> _extractList(dynamic res) {
    if (res is Map && res['data'] is List) {
      return res['data'] as List;
    }
    return [];
  }

  Future<List<IndianStockRaw>> trending() async {
    final res = await _client.getRequest('/trending');
    final list = _extractList(res);
    return list.map((e) => IndianStockRaw.fromJson(e)).toList();
  }

  Future<List<IndianStockRaw>> nseMostActive() async {
    final res = await _client.getRequest('/NSE_most_active');
    final list = _extractList(res);
    return list.map((e) => IndianStockRaw.fromJson(e)).toList();
  }

  Future<List<IndianStockRaw>> bseMostActive() async {
    final res = await _client.getRequest('/BSE_most_active');
    final list = _extractList(res);
    return list.map((e) => IndianStockRaw.fromJson(e)).toList();
  }

  Future<List<IndianStockRaw>> priceShockers() async {
    final res = await _client.getRequest('/price_shockers');
    final list = _extractList(res);
    return list.map((e) => IndianStockRaw.fromJson(e)).toList();
  }

  Future<List<IndianStockRaw>> week52() async {
    final res = await _client.getRequest('/fetch_52_week_high_low_data');
    final list = _extractList(res);
    return list.map((e) => IndianStockRaw.fromJson(e)).toList();
  }
}
