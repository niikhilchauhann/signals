import 'dart:convert';

/// ===============================
/// MAIN PARSER
/// ===============================
List<StockModel> stockListFromJson(String str) =>
    List<StockModel>.from(
      json.decode(str).map((x) => StockModel.fromJson(x)),
    );

/// ===============================
/// STOCK MODEL
/// ===============================
class StockModel {
  final String ticker;
  final String company;
  final double price;
  final double percentChange;
  final double netChange;
  final double bid;
  final double ask;
  final double high;
  final double low;
  final double open;
  final double lowCircuitLimit;
  final double upCircuitLimit;
  final int volume;
  final double close;
  final String overallRating;
  final String shortTermTrend;
  final String longTermTrend;
  final double week52Low;
  final double week52High;

  StockModel({
    required this.ticker,
    required this.company,
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
    required this.close,
    required this.overallRating,
    required this.shortTermTrend,
    required this.longTermTrend,
    required this.week52Low,
    required this.week52High,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      ticker: json['ticker'],
      company: json['company'],
      price: (json['price'] ?? 0).toDouble(),
      percentChange: (json['percent_change'] ?? 0).toDouble(),
      netChange: (json['net_change'] ?? 0).toDouble(),
      bid: (json['bid'] ?? 0).toDouble(),
      ask: (json['ask'] ?? 0).toDouble(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
      open: (json['open'] ?? 0).toDouble(),
      lowCircuitLimit: (json['low_circuit_limit'] ?? 0).toDouble(),
      upCircuitLimit: (json['up_circuit_limit'] ?? 0).toDouble(),
      volume: json['volume'] ?? 0,
      close: (json['close'] ?? 0).toDouble(),
      overallRating: json['overall_rating'] ?? '',
      shortTermTrend: json['short_term_trend'] ?? '',
      longTermTrend: json['long_term_trend'] ?? '',
      week52Low: (json['52_week_low'] ?? 0).toDouble(),
      week52High: (json['52_week_high'] ?? 0).toDouble(),
    );
  }
}
