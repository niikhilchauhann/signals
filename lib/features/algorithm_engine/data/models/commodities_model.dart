import 'dart:convert';

/// ===============================
/// MAIN PARSER
/// ===============================
List<CommodityModel> commodityModelFromJson(String str) =>
    List<CommodityModel>.from(
      json.decode(str).map((x) => CommodityModel.fromJson(x)),
    );

/// ===============================
/// MODEL CLASS
/// ===============================
class CommodityModel {
  final String id;
  final String messageTime;
  final String product;
  final String expiry;
  final String strikePrice;
  final String? optionType;
  final String buyQuantity;
  final String buyPrice;
  final String sellQuantity;
  final String sellPrice;
  final String lastTradedPrice;
  final String lastTradedQuantity;
  final String lastTradedTime;
  final String averageTradedPrice;
  final String totalQuantityTraded;
  final String openInterest;
  final int? openInterestChange;
  final double? openInterestPerChange;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  final String closePrice;
  final String totalTradedValue;
  final String priceQuotationUnit;
  final String quotationLot;
  final String productMonth;
  final num change;
  final num perChange;
  final String? oiResult;
  final bool oiData;

  CommodityModel({
    required this.id,
    required this.messageTime,
    required this.product,
    required this.expiry,
    required this.strikePrice,
    this.optionType,
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
    this.openInterestChange,
    this.openInterestPerChange,
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
    this.oiResult,
    required this.oiData,
  });

  factory CommodityModel.fromJson(Map<String, dynamic> json) {
    return CommodityModel(
      id: json['id'] ?? '',
      messageTime: json['messageTime'] ?? '',
      product: json['product'] ?? '',
      expiry: json['expiry'] ?? '',
      strikePrice: json['strike_price'] ?? '',
      optionType: json['option_type'],
      buyQuantity: json['buy_quantity'] ?? '',
      buyPrice: json['buy_price'] ?? '',
      sellQuantity: json['sell_quantity'] ?? '',
      sellPrice: json['sell_price'] ?? '',
      lastTradedPrice: json['last_traded_price'] ?? '',
      lastTradedQuantity: json['last_traded_quantity'] ?? '',
      lastTradedTime: json['last_traded_time'] ?? '',
      averageTradedPrice: json['average_traded_price'] ?? '',
      totalQuantityTraded: json['total_quantity_traded'] ?? '',
      openInterest: json['open_interest'] ?? '',
      openInterestChange: json['open_interest_change'],
      openInterestPerChange:
          json['open_interest_per_change']?.toDouble(),
      openPrice: json['open_price'] ?? '',
      highPrice: json['high_price'] ?? '',
      lowPrice: json['low_price'] ?? '',
      closePrice: json['close_price'] ?? '',
      totalTradedValue: json['total_traded_value'] ?? '',
      priceQuotationUnit: json['price_quotation_unit'] ?? '',
      quotationLot: json['quotation_lot'] ?? '',
      productMonth: json['product_month'] ?? '',
      change: json['change'] ?? 0,
      perChange: json['per_change'] ?? 0,
      oiResult: json['oiResult'],
      oiData: json['oiData'] ?? false,
    );
  }
}
