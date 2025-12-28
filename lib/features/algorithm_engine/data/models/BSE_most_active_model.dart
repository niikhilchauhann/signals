// To parse this JSON data, do
//
//     final bseMostActive = bseMostActiveFromJson(jsonString);

import 'dart:convert';

List<BseMostActive> bseMostActiveFromJson(String str) => List<BseMostActive>.from(json.decode(str).map((x) => BseMostActive.fromJson(x)));

String bseMostActiveToJson(List<BseMostActive> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BseMostActive {
    String ticker;
    String company;
    double price;
    double percentChange;
    double netChange;
    double bid;
    int ask;
    double high;
    double low;
    double open;
    double lowCircuitLimit;
    double upCircuitLimit;
    int volume;
    double close;
    String overallRating;
    TermTrend shortTermTrend;
    TermTrend longTermTrend;
    double the52WeekLow;
    double the52WeekHigh;

    BseMostActive({
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
        required this.the52WeekLow,
        required this.the52WeekHigh,
    });

    factory BseMostActive.fromJson(Map<String, dynamic> json) => BseMostActive(
        ticker: json["ticker"],
        company: json["company"],
        price: json["price"]?.toDouble(),
        percentChange: json["percent_change"]?.toDouble(),
        netChange: json["net_change"]?.toDouble(),
        bid: json["bid"]?.toDouble(),
        ask: json["ask"],
        high: json["high"]?.toDouble(),
        low: json["low"]?.toDouble(),
        open: json["open"]?.toDouble(),
        lowCircuitLimit: json["low_circuit_limit"]?.toDouble(),
        upCircuitLimit: json["up_circuit_limit"]?.toDouble(),
        volume: json["volume"],
        close: json["close"]?.toDouble(),
        overallRating: json["overall_rating"],
        shortTermTrend: termTrendValues.map[json["short_term_trend"]]!,
        longTermTrend: termTrendValues.map[json["long_term_trend"]]!,
        the52WeekLow: json["52_week_low"]?.toDouble(),
        the52WeekHigh: json["52_week_high"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "ticker": ticker,
        "company": company,
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
        "close": close,
        "overall_rating": overallRating,
        "short_term_trend": termTrendValues.reverse[shortTermTrend],
        "long_term_trend": termTrendValues.reverse[longTermTrend],
        "52_week_low": the52WeekLow,
        "52_week_high": the52WeekHigh,
    };
}

enum TermTrend {
    BEARISH,
    BULLISH,
    MODERATELY_BEARISH,
    NA
}

final termTrendValues = EnumValues({
    "Bearish": TermTrend.BEARISH,
    "Bullish": TermTrend.BULLISH,
    "Moderately Bearish": TermTrend.MODERATELY_BEARISH,
    "NA": TermTrend.NA
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
