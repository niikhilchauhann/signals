import 'package:cupcake/config/api/api_service.dart';

import '../models/ipo_model.dart';
import '../models/commodities_model.dart';
import '../models/mutual_funds_model.dart';
import '../models/news_model.dart';
import '../models/price_shockers_model.dart';
import '../models/stock_lists_model.dart';
import '../models/uni_stock_model.dart';

// class StockRepository {
//   final ApiService _client = ApiService();

//   Future<IpoList> fetchAllIpos() async {
//     final response = await _client.getRequest('/ipo');
//     return IpoList.fromJson(response);
//   }

//   Future<List<NewsArticle>> fetchNews() async {
//     final response = await _client.getRequest('/news');
//     return newsArticleListFromJson(response);
//   }

//   Future<TrendingStockResponse> fetchTrendingStocks() async {
//     final Map<String, dynamic> response = await _client.getRequest('/trending');

//     return TrendingStockResponse.fromJson(response);
//   }

//   Future<List<CommodityModel>> fetchCommodities() async {
//     final response = await _client.getRequest('/commodities');
//     return commodityModelFromJson(response);
//   }

//   Future<MutualFundResponse> fetchMutualFunds() async {
//     final response = await _client.getRequest('/mutual_funds');
//     return MutualFundResponse.fromJson(response);
//   }

//   Future<PriceShockerResponse> fetchPriceShockers() async {
//     final Map<String, dynamic> response = await _client.getRequest(
//       '/price_shockers',
//     );

//     return PriceShockerResponse.fromJson(response);
//   }

//   Future<List<StockModel>> fetchBseMostActiveStocks() async {
//     final List<dynamic> response = await _client.getRequest('/BSE_most_active');

//     return response
//         .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   Future<List<StockModel>> fetchNseMostActiveStocks() async {
//     final List<dynamic> response = await _client.getRequest('/NSE_most_active');

//     return response
//         .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   Future<Week52Response> fetchWeek52Data() async {
//     final Map<String, dynamic> response = await _client.getRequest(
//       '/fetch_52_week_high_low_data',
//     );

//     return Week52Response.fromJson(response);
//   }
// }

class StockRepository {
  final ApiService _client = ApiService();

  // 12-hour cache
  static const Duration _shortTtl = Duration(hours: 12);

  // 24-hour cache
  static const Duration _longTtl = Duration(days: 1);

  Future<IpoList> fetchAllIpos({bool forceRefresh = false}) async {
    final response = await _client.getRequest('/ipo', ttl: _shortTtl, forceRefresh: forceRefresh);
    return IpoList.fromJson(response);
  }

  Future<List<NewsArticle>> fetchNews({bool forceRefresh = false}) async {
    final response = await _client.getRequest('/news', ttl: _shortTtl, forceRefresh: forceRefresh);
    return newsArticleListFromJson(response);
  }

  Future<TrendingStockResponse> fetchTrendingStocks({bool forceRefresh = false}) async {
    final Map<String, dynamic> response =
        await _client.getRequest('/trending', ttl: _longTtl, forceRefresh: forceRefresh);
    return TrendingStockResponse.fromJson(response);
  }

  Future<List<CommodityModel>> fetchCommodities({bool forceRefresh = false}) async {
    final response =
        await _client.getRequest('/commodities', ttl: _shortTtl, forceRefresh: forceRefresh);
    return commodityModelFromJson(response);
  }

  Future<MutualFundResponse> fetchMutualFunds({bool forceRefresh = false}) async {
    final response =
        await _client.getRequest('/mutual_funds', ttl: _shortTtl, forceRefresh: forceRefresh);
    return MutualFundResponse.fromJson(response);
  }

  Future<PriceShockerResponse> fetchPriceShockers({bool forceRefresh = false}) async {
    final Map<String, dynamic> response =
        await _client.getRequest('/price_shockers', ttl: _longTtl, forceRefresh: forceRefresh);
    return PriceShockerResponse.fromJson(response);
  }

  Future<List<StockModel>> fetchBseMostActiveStocks({bool forceRefresh = false}) async {
    final List<dynamic> response =
        await _client.getRequest('/BSE_most_active', ttl: _longTtl, forceRefresh: forceRefresh);
    return response
        .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<StockModel>> fetchNseMostActiveStocks({bool forceRefresh = false}) async {
    final List<dynamic> response =
        await _client.getRequest('/NSE_most_active', ttl: _longTtl, forceRefresh: forceRefresh);
    return response
        .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Week52Response> fetchWeek52Data({bool forceRefresh = false}) async {
    final Map<String, dynamic> response = await _client.getRequest(
      '/fetch_52_week_high_low_data',
      ttl: _longTtl,
      forceRefresh: forceRefresh,
    );

    return Week52Response.fromJson(response);
  }
}
