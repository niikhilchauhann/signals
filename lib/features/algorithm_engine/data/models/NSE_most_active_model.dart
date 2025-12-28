// To parse this JSON data, do
//
//     final nseMostActive = nseMostActiveFromJson(jsonString);

import 'dart:convert';

List<NseMostActive> nseMostActiveFromJson(String str) => List<NseMostActive>.from(json.decode(str).map((x) => NseMostActive.fromJson(x)));

String nseMostActiveToJson(List<NseMostActive> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NseMostActive {
    String ticker;
    String company;
    double price;
    double percentChange;
    double netChange;
    double bid;
    double ask;
    double high;
    double low;
    double open;
    double lowCircuitLimit;
    double upCircuitLimit;
    int volume;
    double close;
    String overallRating;
    String shortTermTrend;
    String longTermTrend;
    double the52WeekLow;
    double the52WeekHigh;

    NseMostActive({
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

    factory NseMostActive.fromJson(Map<String, dynamic> json) => NseMostActive(
        ticker: json["ticker"],
        company: json["company"],
        price: json["price"]?.toDouble(),
        percentChange: json["percent_change"]?.toDouble(),
        netChange: json["net_change"]?.toDouble(),
        bid: json["bid"]?.toDouble(),
        ask: json["ask"]?.toDouble(),
        high: json["high"]?.toDouble(),
        low: json["low"]?.toDouble(),
        open: json["open"]?.toDouble(),
        lowCircuitLimit: json["low_circuit_limit"]?.toDouble(),
        upCircuitLimit: json["up_circuit_limit"]?.toDouble(),
        volume: json["volume"],
        close: json["close"]?.toDouble(),
        overallRating: json["overall_rating"],
        shortTermTrend: json["short_term_trend"],
        longTermTrend: json["long_term_trend"],
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
        "short_term_trend": shortTermTrend,
        "long_term_trend": longTermTrend,
        "52_week_low": the52WeekLow,
        "52_week_high": the52WeekHigh,
    };
}
