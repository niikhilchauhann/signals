String _asString(dynamic v) {
  if (v == null) return '';
  if (v is String) return v;
  if (v is num) return v.toString();
  return '';
}


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
  final String close;
  final String overallRating;
  final String shortTermTrends;
  final String longTermTrends;
  final String yearLow;
  final String yearHigh;

  final String? date;
  final String? time;
  final String? bidSize;
  final String? askSize;
  final String? exchangeType;
  final String? lotSize;
  final String? totalShareOutstanding;
  final String? ric;

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
    required this.close,
    required this.overallRating,
    required this.shortTermTrends,
    required this.longTermTrends,
    required this.yearLow,
    required this.yearHigh,

     this.date,
     this.time,
     this.bidSize,
     this.askSize,
     this.exchangeType,
     this.lotSize,
     this.totalShareOutstanding,
     this.ric,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      tickerId: json['ticker'] ?? json['ticker_id'] ?? '',
      companyName: json['company'] ?? json['company_name'] ?? '',

      price: _asString(json['price']),
      percentChange: _asString(json['percent_change']),
      netChange: _asString(json['net_change']),
      bid: _asString(json['bid']),
      ask: _asString(json['ask']),
      high: _asString(json['high']),
      low: _asString(json['low']),
      open: _asString(json['open']),
      lowCircuitLimit: _asString(json['low_circuit_limit']),
      upCircuitLimit: _asString(json['up_circuit_limit']),
      volume: _asString(json['volume']),
      close: _asString(json['close']),
      overallRating: _asString(json['overall_rating']),
      shortTermTrends: _asString(json['short_term_trends']),
      longTermTrends: _asString(json['long_term_trends']),
      yearLow: _asString(json['52_week_low'] ?? json['year_low']),
      yearHigh: _asString(json['52_week_high'] ?? json['year_high']),

      // price: json['price'] ?? '',
      // percentChange: json['percent_change'] ?? '',
      // netChange: json['net_change'] ?? '',
      // bid: json['bid'] ?? '',
      // ask: json['ask'] ?? '',
      // high: json['high'] ?? '',
      // low: json['low'] ?? '',
      // open: json['open'] ?? '',
      // lowCircuitLimit: json['low_circuit_limit'] ?? '',
      // upCircuitLimit: json['up_circuit_limit'] ?? '',
      // volume: json['volume'] ?? '',
      // close: json['close'] ?? '',
      // overallRating: json['overall_rating'] ?? '',
      // shortTermTrends: json['short_term_trends'] ?? '',
      // longTermTrends: json['long_term_trends'] ?? '',
      // yearLow: json['52_week_low'] ?? json['year_low'] ?? '',
      // yearHigh: json['52_week_high'] ?? json['year_high'] ?? '',

      date: json['date'] ?? '',
      time: json['time'] ?? '',
      bidSize: json['bid_size'] ?? '',
      askSize: json['ask_size'] ?? '',
      exchangeType: json['exchange_type'] ?? '',
      lotSize: json['lot_size'] ?? '',
      totalShareOutstanding: json['total_share_outstanding'] ?? '',
      ric: json['ric'] ?? '',
    );
  }
}