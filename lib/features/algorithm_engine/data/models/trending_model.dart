// To parse this JSON data, do
//
//     final trendingStocks = trendingStocksFromJson(jsonString);

import 'dart:convert';

TrendingStocks trendingStocksFromJson(String str) => TrendingStocks.fromJson(json.decode(str));

String trendingStocksToJson(TrendingStocks data) => json.encode(data.toJson());

class TrendingStocks {
    TrendingStocksClass trendingStocks;

    TrendingStocks({
        required this.trendingStocks,
    });

    factory TrendingStocks.fromJson(Map<String, dynamic> json) => TrendingStocks(
        trendingStocks: TrendingStocksClass.fromJson(json["trending_stocks"]),
    );

    Map<String, dynamic> toJson() => {
        "trending_stocks": trendingStocks.toJson(),
    };
}

class TrendingStocksClass {
    List<Top> topGainers;
    List<Top> topLosers;

    TrendingStocksClass({
        required this.topGainers,
        required this.topLosers,
    });

    factory TrendingStocksClass.fromJson(Map<String, dynamic> json) => TrendingStocksClass(
        topGainers: List<Top>.from(json["top_gainers"].map((x) => Top.fromJson(x))),
        topLosers: List<Top>.from(json["top_losers"].map((x) => Top.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "top_gainers": List<dynamic>.from(topGainers.map((x) => x.toJson())),
        "top_losers": List<dynamic>.from(topLosers.map((x) => x.toJson())),
    };
}

class Top {
    String tickerId;
    String companyName;
    String price;
    String percentChange;
    String netChange;
    String bid;
    String ask;
    String high;
    String low;
    String open;
    String lowCircuitLimit;
    String upCircuitLimit;
    String volume;
    DateTime date;
    String time;
    String close;
    String bidSize;
    String askSize;
    ExchangeType exchangeType;
    String lotSize;
    LongTermTrends overallRating;
    LongTermTrends shortTermTrends;
    LongTermTrends longTermTrends;
    String totalShareOutstanding;
    String yearLow;
    String yearHigh;
    String ric;

    Top({
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

    factory Top.fromJson(Map<String, dynamic> json) => Top(
        tickerId: json["ticker_id"],
        companyName: json["company_name"],
        price: json["price"],
        percentChange: json["percent_change"],
        netChange: json["net_change"],
        bid: json["bid"],
        ask: json["ask"],
        high: json["high"],
        low: json["low"],
        open: json["open"],
        lowCircuitLimit: json["low_circuit_limit"],
        upCircuitLimit: json["up_circuit_limit"],
        volume: json["volume"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        close: json["close"],
        bidSize: json["bid_size"],
        askSize: json["ask_size"],
        exchangeType: exchangeTypeValues.map[json["exchange_type"]]!,
        lotSize: json["lot_size"],
        overallRating: longTermTrendsValues.map[json["overall_rating"]]!,
        shortTermTrends: longTermTrendsValues.map[json["short_term_trends"]]!,
        longTermTrends: longTermTrendsValues.map[json["long_term_trends"]]!,
        totalShareOutstanding: json["total_share_outstanding"],
        yearLow: json["year_low"],
        yearHigh: json["year_high"],
        ric: json["ric"],
    );

    Map<String, dynamic> toJson() => {
        "ticker_id": tickerId,
        "company_name": companyName,
        "price": price,
        "percent_change": percentChange,
        "net_change": netChange,
        "bid": bid,
        "ask": ask,
        "high": high,
        "low": low,
        "open": open,
        "low_circuit_limit": lowCircuitLimit,
        "up_circuit_limit": upCircuitLimit,
        "volume": volume,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "close": close,
        "bid_size": bidSize,
        "ask_size": askSize,
        "exchange_type": exchangeTypeValues.reverse[exchangeType],
        "lot_size": lotSize,
        "overall_rating": longTermTrendsValues.reverse[overallRating],
        "short_term_trends": longTermTrendsValues.reverse[shortTermTrends],
        "long_term_trends": longTermTrendsValues.reverse[longTermTrends],
        "total_share_outstanding": totalShareOutstanding,
        "year_low": yearLow,
        "year_high": yearHigh,
        "ric": ric,
    };
}

enum ExchangeType {
    NSI
}

final exchangeTypeValues = EnumValues({
    "NSI": ExchangeType.NSI
});

enum LongTermTrends {
    BEARISH,
    BULLISH,
    MODERATELY_BEARISH,
    MODERATELY_BULLISH,
    NA,
    NEUTRAL
}

final longTermTrendsValues = EnumValues({
    "Bearish": LongTermTrends.BEARISH,
    "Bullish": LongTermTrends.BULLISH,
    "Moderately Bearish": LongTermTrends.MODERATELY_BEARISH,
    "Moderately Bullish": LongTermTrends.MODERATELY_BULLISH,
    "NA": LongTermTrends.NA,
    "Neutral": LongTermTrends.NEUTRAL
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
