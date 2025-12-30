import 'package:cupcake/config/api/api_service.dart';

import '../models/ipo_model.dart';
import '../models/BSE_most_active_model.dart';
import '../models/commodities_model.dart';
import '../models/mutual_funds_model.dart';
import '../models/news_model.dart';
import '../models/NSE_most_active_model.dart';
import '../models/price_shockers_model.dart';
import '../models/trending_model.dart';
import '../models/week_high_low_data_model.dart';

class StockRepository {
  final ApiService _client = ApiService();

  Future<IpoList> fetchAllIpos() async {
    final response = await _client.getRequest('/ipo');

    return IpoList.fromJson(response);
  } 

  Future<List<StockModel>> fetchBseMostActiveStocks() async {
    final response = await _client.getRequest('/bse/most-active');

    return stockListFromJson(response);
  }

  Future<List<CommodityModel>> fetchCommodities() async {
    final response = await _client.getRequest('/commodities');

    return commodityModelFromJson(response);
  }

  Future<MutualFundResponse> fetchMutualFunds() async {
    final response = await _client.getRequest('/mutual-funds');

    return MutualFundResponse.fromJson(response);
  }

  Future<List<NewsArticle>> fetchNews() async {
    final response = await _client.getRequest('/news');

    return newsArticleListFromJson(response);
  }

   Future<List<NseStockModel>> fetchNseStocks() async {
    final response = await _client.getRequest('/nse/stocks');

    return nseStockListFromJson(response);
  }

   Future<BsePriceShockerResponse> fetchPriceShockers() async {
    final response = await _client.getRequest('/price-shocker');

    return BsePriceShockerResponse.fromJson(response);
  }

  Future<TrendingStockResponse> fetchTrendingStocks() async {
    final response = await _client.getRequest('/trending-stocks');

    return trendingStockResponseFromJson(response);
  }

   Future<Week52Response> fetchWeek52Data() async {
    final response = await _client.getRequest('/week52-high-low');
    return Week52Response.fromJson(response);
  }
}


