// To parse this JSON data, do
//
//     final commodities = commoditiesFromJson(jsonString);

import 'dart:convert';

List<Commodities> commoditiesFromJson(String str) => List<Commodities>.from(json.decode(str).map((x) => Commodities.fromJson(x)));

String commoditiesToJson(List<Commodities> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Commodities {
    String id;
    DateTime messageTime;
    String product;
    String expiry;
    String strikePrice;
    dynamic optionType;
    String buyQuantity;
    String buyPrice;
    String sellQuantity;
    String sellPrice;
    String lastTradedPrice;
    String lastTradedQuantity;
    DateTime lastTradedTime;
    String averageTradedPrice;
    String totalQuantityTraded;
    String openInterest;
    int? openInterestChange;
    double? openInterestPerChange;
    String openPrice;
    String highPrice;
    String lowPrice;
    String closePrice;
    String totalTradedValue;
    PriceQuotationUnit priceQuotationUnit;
    String quotationLot;
    String productMonth;
    double change;
    double perChange;
    String? oiResult;
    bool oiData;

    Commodities({
        required this.id,
        required this.messageTime,
        required this.product,
        required this.expiry,
        required this.strikePrice,
        required this.optionType,
        required this.buyQuantity,
        required this.buyPrice,
        required this.sellQuantity,
        required this.sellPrice,
        required this.lastTradedPrice,
        required this.lastTradedQuantity,
        required this.lastTradedTime,
        required this.averageTradedPrice,
        required this.totalQuantityTraded,
        required this.openInterest,
        required this.openInterestChange,
        required this.openInterestPerChange,
        required this.openPrice,
        required this.highPrice,
        required this.lowPrice,
        required this.closePrice,
        required this.totalTradedValue,
        required this.priceQuotationUnit,
        required this.quotationLot,
        required this.productMonth,
        required this.change,
        required this.perChange,
        required this.oiResult,
        required this.oiData,
    });

    factory Commodities.fromJson(Map<String, dynamic> json) => Commodities(
        id: json["id"],
        messageTime: DateTime.parse(json["messageTime"]),
        product: json["product"],
        expiry: json["expiry"],
        strikePrice: json["strike_price"],
        optionType: json["option_type"],
        buyQuantity: json["buy_quantity"],
        buyPrice: json["buy_price"],
        sellQuantity: json["sell_quantity"],
        sellPrice: json["sell_price"],
        lastTradedPrice: json["last_traded_price"],
        lastTradedQuantity: json["last_traded_quantity"],
        lastTradedTime: DateTime.parse(json["last_traded_time"]),
        averageTradedPrice: json["average_traded_price"],
        totalQuantityTraded: json["total_quantity_traded"],
        openInterest: json["open_interest"],
        openInterestChange: json["open_interest_change"],
        openInterestPerChange: json["open_interest_per_change"]?.toDouble(),
        openPrice: json["open_price"],
        highPrice: json["high_price"],
        lowPrice: json["low_price"],
        closePrice: json["close_price"],
        totalTradedValue: json["total_traded_value"],
        priceQuotationUnit: priceQuotationUnitValues.map[json["price_quotation_unit"]]!,
        quotationLot: json["quotation_lot"],
        productMonth: json["product_month"],
        change: json["change"]?.toDouble(),
        perChange: json["per_change"]?.toDouble(),
        oiResult: json["oiResult"],
        oiData: json["oiData"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "messageTime": messageTime.toIso8601String(),
        "product": product,
        "expiry": expiry,
        "strike_price": strikePrice,
        "option_type": optionType,
        "buy_quantity": buyQuantity,
        "buy_price": buyPrice,
        "sell_quantity": sellQuantity,
        "sell_price": sellPrice,
        "last_traded_price": lastTradedPrice,
        "last_traded_quantity": lastTradedQuantity,
        "last_traded_time": lastTradedTime.toIso8601String(),
        "average_traded_price": averageTradedPrice,
        "total_quantity_traded": totalQuantityTraded,
        "open_interest": openInterest,
        "open_interest_change": openInterestChange,
        "open_interest_per_change": openInterestPerChange,
        "open_price": openPrice,
        "high_price": highPrice,
        "low_price": lowPrice,
        "close_price": closePrice,
        "total_traded_value": totalTradedValue,
        "price_quotation_unit": priceQuotationUnitValues.reverse[priceQuotationUnit],
        "quotation_lot": quotationLot,
        "product_month": productMonth,
        "change": change,
        "per_change": perChange,
        "oiResult": oiResult,
        "oiData": oiData,
    };
}

enum PriceQuotationUnit {
    BBL,
    KGS,
    UNIT
}

final priceQuotationUnitValues = EnumValues({
    "BBL": PriceQuotationUnit.BBL,
    "KGS": PriceQuotationUnit.KGS,
    "UNIT": PriceQuotationUnit.UNIT
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
