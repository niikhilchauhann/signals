import 'package:cupcake/config/api/api_service.dart';

import '../models/ipo_model.dart';
import '../models/commodities_model.dart';
import '../models/mutual_funds_model.dart';
import '../models/news_model.dart';
import '../models/price_shockers_model.dart';
import '../models/stock_lists_model.dart';
import '../models/uni_stock_model.dart';

class StockRepository {
  final ApiService _client = ApiService();

  Future<IpoList> fetchAllIpos() async {
    final response = await _client.getRequest('/ipo');
    return IpoList.fromJson(response);
  }

  Future<List<NewsArticle>> fetchNews() async {
    final response = await _client.getRequest('/news');
    return newsArticleListFromJson(response);
  }

  Future<TrendingStockResponse> fetchTrendingStocks() async {
    final Map<String, dynamic> response = await _client.getRequest('/trending');

    return TrendingStockResponse.fromJson(response);
  }

  Future<List<CommodityModel>> fetchCommodities() async {
    final response = await _client.getRequest('/commodities');
    return commodityModelFromJson(response);
  }

  Future<MutualFundResponse> fetchMutualFunds() async {
    final response = await _client.getRequest('/mutual_funds');
    return MutualFundResponse.fromJson(response);
  }

  Future<PriceShockerResponse> fetchPriceShockers() async {
    final Map<String, dynamic> response = await _client.getRequest(
      '/price_shockers',
    );

    return PriceShockerResponse.fromJson(response);
  }

  Future<List<StockModel>> fetchBseMostActiveStocks() async {
    final List<dynamic> response = await _client.getRequest('/BSE_most_active');

    return response
        .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<StockModel>> fetchNseMostActiveStocks() async {
    final List<dynamic> response = await _client.getRequest('/NSE_most_active');

    return response
        .map((e) => StockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Week52Response> fetchWeek52Data() async {
    final Map<String, dynamic> response = await _client.getRequest(
      '/fetch_52_week_high_low_data',
    );

    return Week52Response.fromJson(response);
  }
}
