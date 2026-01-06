
import 'dart:convert';

import 'uni_stock_model.dart';

List<StockModel> bseStockListFromJson(String str) =>
    List<StockModel>.from(
      json.decode(str).map((x) => StockModel.fromJson(x)),
    );

List<StockModel> nseStockListFromJson(String str) =>
    List<StockModel>.from(
      json.decode(str).map((x) => StockModel.fromJson(x)),
    );

TrendingStockResponse trendingStockResponseFromJson(String str) =>
    TrendingStockResponse.fromJson(json.decode(str));

class TrendingStockResponse {
  final TrendingStocks trendingStocks;

  TrendingStockResponse({required this.trendingStocks});

  factory TrendingStockResponse.fromJson(Map<String, dynamic> json) {
    return TrendingStockResponse(
      trendingStocks:
          TrendingStocks.fromJson(json['trending_stocks']),
    );
  }
}

class TrendingStocks {
  final List<StockModel> topGainers;
  final List<StockModel> topLosers;

  TrendingStocks({
    required this.topGainers,
    required this.topLosers,
  });

  factory TrendingStocks.fromJson(Map<String, dynamic> json) {
    return TrendingStocks(
      topGainers: List<StockModel>.from(
        json['top_gainers'].map((x) => StockModel.fromJson(x)),
      ),
      topLosers: List<StockModel>.from(
        json['top_losers'].map((x) => StockModel.fromJson(x)),
      ),
    );
  }
}

class Week52Response {
  final Exchange52Data bse;
  final Exchange52Data nse;

  Week52Response({
    required this.bse,
    required this.nse,
  });

  factory Week52Response.fromJson(Map<String, dynamic> json) {
    return Week52Response(
      bse: Exchange52Data.fromJson(json['BSE_52WeekHighLow']),
      nse: Exchange52Data.fromJson(json['NSE_52WeekHighLow']),
    );
  }
}

class Exchange52Data {
  final List<Week52High> high52Week;
  final List<Week52Low> low52Week;

  Exchange52Data({
    required this.high52Week,
    required this.low52Week,
  });

  factory Exchange52Data.fromJson(Map<String, dynamic> json) {
    return Exchange52Data(
      high52Week: (json['high52Week'] as List)
          .map((e) => Week52High.fromJson(e))
          .toList(),
      low52Week: (json['low52Week'] as List)
          .map((e) => Week52Low.fromJson(e))
          .toList(),
    );
  }
}

class Week52High {
  final String ticker;
  final String company;
  final double price;
  final double high52Week;

  Week52High({
    required this.ticker,
    required this.company,
    required this.price,
    required this.high52Week,
  });

  factory Week52High.fromJson(Map<String, dynamic> json) {
    return Week52High(
      ticker: json['ticker'],
      company: json['company'],
      price: (json['price'] ?? 0).toDouble(),
      high52Week: (json['52_week_high'] ?? 0).toDouble(),
    );
  }
}

class Week52Low {
  final String ticker;
  final String company;
  final double price;
  final double low52Week;

  Week52Low({
    required this.ticker,
    required this.company,
    required this.price,
    required this.low52Week,
  });

  factory Week52Low.fromJson(Map<String, dynamic> json) {
    return Week52Low(
      ticker: json['ticker'],
      company: json['company'],
      price: (json['price'] ?? 0).toDouble(),
      low52Week: (json['52_week_low'] ?? 0).toDouble(),
    );
  }
}
