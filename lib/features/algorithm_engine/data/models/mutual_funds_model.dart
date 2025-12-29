import 'dart:convert';

/// ================================
/// MAIN RESPONSE MODEL
/// ================================
class MutualFundResponse {
  final Map<String, Map<String, List<FundModel>>> data;

  MutualFundResponse({required this.data});

  factory MutualFundResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, Map<String, List<FundModel>>> parsed = {};

    json.forEach((mainCategory, subCategories) {
      final Map<String, List<FundModel>> innerMap = {};

      (subCategories as Map<String, dynamic>).forEach((subKey, fundList) {
        innerMap[subKey] = (fundList as List)
            .map((e) => FundModel.fromJson(e))
            .toList();
      });

      parsed[mainCategory] = innerMap;
    });

    return MutualFundResponse(data: parsed);
  }
}

/// ================================
/// FUND MODEL
/// ================================
class FundModel {
  final String fundName;
  final double? latestNav;
  final double? percentageChange;
  final double? assetSize;

  final double? oneMonthReturn;
  final double? threeMonthReturn;
  final double? sixMonthReturn;
  final double? oneYearReturn;
  final double? threeYearReturn;
  final double? fiveYearReturn;

  final int? starRating;

  FundModel({
    required this.fundName,
    this.latestNav,
    this.percentageChange,
    this.assetSize,
    this.oneMonthReturn,
    this.threeMonthReturn,
    this.sixMonthReturn,
    this.oneYearReturn,
    this.threeYearReturn,
    this.fiveYearReturn,
    this.starRating,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      fundName: json['fund_name'] ?? '',
      latestNav: _toDouble(json['latest_nav']),
      percentageChange: _toDouble(json['percentage_change']),
      assetSize: _toDouble(json['asset_size']),
      oneMonthReturn: _toDouble(json['1_month_return']),
      threeMonthReturn: _toDouble(json['3_month_return']),
      sixMonthReturn: _toDouble(json['6_month_return']),
      oneYearReturn: _toDouble(json['1_year_return']),
      threeYearReturn: _toDouble(json['3_year_return']),
      fiveYearReturn: _toDouble(json['5_year_return']),
      starRating: json['star_rating'],
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }
}
