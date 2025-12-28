// To parse this JSON data, do
//
//     final priceShockers = priceShockersFromJson(jsonString);

import 'dart:convert';

PriceShockers priceShockersFromJson(String str) => PriceShockers.fromJson(json.decode(str));

String priceShockersToJson(PriceShockers data) => json.encode(data.toJson());

class PriceShockers {
    List<Map<String, String?>> bsePriceShocker;
    List<Map<String, String?>> nsePriceShocker;

    PriceShockers({
        required this.bsePriceShocker,
        required this.nsePriceShocker,
    });

    factory PriceShockers.fromJson(Map<String, dynamic> json) => PriceShockers(
        bsePriceShocker: List<Map<String, String?>>.from(json["BSE_PriceShocker"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
        nsePriceShocker: List<Map<String, String?>>.from(json["NSE_PriceShocker"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
    );

    Map<String, dynamic> toJson() => {
        "BSE_PriceShocker": List<dynamic>.from(bsePriceShocker.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "NSE_PriceShocker": List<dynamic>.from(nsePriceShocker.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
    };
}
