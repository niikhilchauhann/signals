class PriceShockerResponse {
  final List<PriceShockerStock> stocks;

  PriceShockerResponse({required this.stocks});

  factory PriceShockerResponse.fromJson(Map<String, dynamic> json) {
    return PriceShockerResponse(
      stocks: (json['BSE_PriceShocker'] as List)
          .map((e) => PriceShockerStock.fromJson(e))
          .toList(),
    );
  }
}

class PriceShockerStock {
  final String tickerId;
  final String ric;
  final String nseCode;
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
  final String displayName;
  final String? date;
  final String? time;
  final String? priceArrow;
  final String close;
  final String bidSize;
  final String askSize;
  final String averagePrice;
  final String? averageVolume;
  final String exchangeType;
  final String lotSize;
  final String deviation;
  final String actualDeviation;
  final String noOfDaysForAverage;
  final String? yearHighDate;
  final String? yearLowDate;
  final String tick;
  final String totalShareOutstanding;
  final String marketCap;
  final String shortTermTrends;
  final String longTermTrends;
  final String? sma;
  final String overallRating;
  final String description;
  final String isin;
  final String? ylow;
  final String? yhigh;

  PriceShockerStock({
    required this.tickerId,
    required this.ric,
    required this.nseCode,
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
    required this.displayName,
    this.date,
    this.time,
    this.priceArrow,
    required this.close,
    required this.bidSize,
    required this.askSize,
    required this.averagePrice,
    this.averageVolume,
    required this.exchangeType,
    required this.lotSize,
    required this.deviation,
    required this.actualDeviation,
    required this.noOfDaysForAverage,
    this.yearHighDate,
    this.yearLowDate,
    required this.tick,
    required this.totalShareOutstanding,
    required this.marketCap,
    required this.shortTermTrends,
    required this.longTermTrends,
    this.sma,
    required this.overallRating,
    required this.description,
    required this.isin,
    this.ylow,
    this.yhigh,
  });

  factory PriceShockerStock.fromJson(Map<String, dynamic> json) {
    return PriceShockerStock(
      tickerId: json['tickerId'] ?? '',
      ric: json['ric'] ?? '',
      nseCode: json['nseCode'] ?? '',
      price: json['price'] ?? '',
      percentChange: json['percentChange'] ?? '',
      netChange: json['netChange'] ?? '',
      bid: json['bid'] ?? '',
      ask: json['ask'] ?? '',
      high: json['high'] ?? '',
      low: json['low'] ?? '',
      open: json['open'] ?? '',
      lowCircuitLimit: json['lowCircuitLimit'] ?? '',
      upCircuitLimit: json['upCircuitLimit'] ?? '',
      volume: json['volume'] ?? '',
      displayName: json['displayName'] ?? '',
      date: json['date'],
      time: json['time'],
      priceArrow: json['priceArrow'],
      close: json['close'] ?? '',
      bidSize: json['bidSize'] ?? '',
      askSize: json['askSize'] ?? '',
      averagePrice: json['averagePrice'] ?? '',
      averageVolume: json['averageVolume'],
      exchangeType: json['exchangeType'] ?? '',
      lotSize: json['lotSize'] ?? '',
      deviation: json['deviation'] ?? '',
      actualDeviation: json['actualDeviation'] ?? '',
      noOfDaysForAverage: json['noOfDaysForAverage'] ?? '',
      yearHighDate: json['yearHighDate'],
      yearLowDate: json['yearLowDate'],
      tick: json['tick'] ?? '',
      totalShareOutstanding: json['totalShareOutstanding'] ?? '',
      marketCap: json['marketCap'] ?? '',
      shortTermTrends: json['shortTermTrends'] ?? '',
      longTermTrends: json['longTermTrends'] ?? '',
      sma: json['sma'],
      overallRating: json['overallRating'] ?? '',
      description: json['description'] ?? '',
      isin: json['isInId'] ?? '',
      ylow: json['ylow'],
      yhigh: json['yhigh'],
    );
  }
}
