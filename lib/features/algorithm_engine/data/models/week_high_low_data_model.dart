// To parse this JSON data, do
//
//     final weekHighLowData = weekHighLowDataFromJson(jsonString);

import 'dart:convert';

WeekHighLowData weekHighLowDataFromJson(String str) => WeekHighLowData.fromJson(json.decode(str));

String weekHighLowDataToJson(WeekHighLowData data) => json.encode(data.toJson());

class WeekHighLowData {
    Se52WeekHighLow bse52WeekHighLow;
    Se52WeekHighLow nse52WeekHighLow;

    WeekHighLowData({
        required this.bse52WeekHighLow,
        required this.nse52WeekHighLow,
    });

    factory WeekHighLowData.fromJson(Map<String, dynamic> json) => WeekHighLowData(
        bse52WeekHighLow: Se52WeekHighLow.fromJson(json["BSE_52WeekHighLow"]),
        nse52WeekHighLow: Se52WeekHighLow.fromJson(json["NSE_52WeekHighLow"]),
    );

    Map<String, dynamic> toJson() => {
        "BSE_52WeekHighLow": bse52WeekHighLow.toJson(),
        "NSE_52WeekHighLow": nse52WeekHighLow.toJson(),
    };
}

class Se52WeekHighLow {
    List<The52Week> high52Week;
    List<The52Week> low52Week;

    Se52WeekHighLow({
        required this.high52Week,
        required this.low52Week,
    });

    factory Se52WeekHighLow.fromJson(Map<String, dynamic> json) => Se52WeekHighLow(
        high52Week: List<The52Week>.from(json["high52Week"].map((x) => The52Week.fromJson(x))),
        low52Week: List<The52Week>.from(json["low52Week"].map((x) => The52Week.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "high52Week": List<dynamic>.from(high52Week.map((x) => x.toJson())),
        "low52Week": List<dynamic>.from(low52Week.map((x) => x.toJson())),
    };
}

class The52Week {
    String ticker;
    String company;
    double price;
    double? the52WeekHigh;
    double? the52WeekLow;

    The52Week({
        required this.ticker,
        required this.company,
        required this.price,
        this.the52WeekHigh,
        this.the52WeekLow,
    });

    factory The52Week.fromJson(Map<String, dynamic> json) => The52Week(
        ticker: json["ticker"],
        company: json["company"],
        price: json["price"]?.toDouble(),
        the52WeekHigh: json["52_week_high"]?.toDouble(),
        the52WeekLow: json["52_week_low"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "ticker": ticker,
        "company": company,
        "price": price,
        "52_week_high": the52WeekHigh,
        "52_week_low": the52WeekLow,
    };
}
