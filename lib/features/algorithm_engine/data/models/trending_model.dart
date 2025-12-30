import 'dart:convert';

/// ===============================
/// MAIN RESPONSE
/// ===============================
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

/// ===============================
/// TRENDING STOCKS
/// ===============================
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

/// ===============================
/// STOCK MODEL
/// ===============================
class StockModel {
  final String tickerId;
  final String companyName;
  final String price;
  final String percentChange;
  final String netChange;
  final String bid;
  final String ask;
  final String high;
  final String low;
  final String open;
  final String lowCircuitLimit;
  final String upCircuitLimit;
  final String volume;
  final String date;
  final String time;
  final String close;
  final String bidSize;
  final String askSize;
  final String exchangeType;
  final String lotSize;
  final String overallRating;
  final String shortTermTrends;
  final String longTermTrends;
  final String totalShareOutstanding;
  final String yearLow;
  final String yearHigh;
  final String ric;

  StockModel({
    required this.tickerId,
    required this.companyName,
    required this.price,
    required this.percentChange,
    required this.netChange,
    required this.bid,
    required this.ask,
    required this.high,
    required this.low,
    required this.open,
    required this.lowCircuitLimit,
    required this.upCircuitLimit,
    required this.volume,
    required this.date,
    required this.time,
    required this.close,
    required this.bidSize,
    required this.askSize,
    required this.exchangeType,
    required this.lotSize,
    required this.overallRating,
    required this.shortTermTrends,
    required this.longTermTrends,
    required this.totalShareOutstanding,
    required this.yearLow,
    required this.yearHigh,
    required this.ric,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      tickerId: json['ticker_id'] ?? '',
      companyName: json['company_name'] ?? '',
      price: json['price'] ?? '',
      percentChange: json['percent_change'] ?? '',
      netChange: json['net_change'] ?? '',
      bid: json['bid'] ?? '',
      ask: json['ask'] ?? '',
      high: json['high'] ?? '',
      low: json['low'] ?? '',
      open: json['open'] ?? '',
      lowCircuitLimit: json['low_circuit_limit'] ?? '',
      upCircuitLimit: json['up_circuit_limit'] ?? '',
      volume: json['volume'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      close: json['close'] ?? '',
      bidSize: json['bid_size'] ?? '',
      askSize: json['ask_size'] ?? '',
      exchangeType: json['exchange_type'] ?? '',
      lotSize: json['lot_size'] ?? '',
      overallRating: json['overall_rating'] ?? '',
      shortTermTrends: json['short_term_trends'] ?? '',
      longTermTrends: json['long_term_trends'] ?? '',
      totalShareOutstanding: json['total_share_outstanding'] ?? '',
      yearLow: json['year_low'] ?? '',
      yearHigh: json['year_high'] ?? '',
      ric: json['ric'] ?? '',
    );
  }
}
