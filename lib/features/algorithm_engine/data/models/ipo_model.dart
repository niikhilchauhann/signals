// To parse this JSON data, do
//
//     final ipoList = ipoListFromJson(jsonString);

import 'dart:convert';

IpoList ipoListFromJson(String str) => IpoList.fromJson(json.decode(str));

String ipoListToJson(IpoList data) => json.encode(data.toJson());

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

class IpoList {
  List<IPOModel> upcoming;
  List<IPOModel> listed;
  List<IPOModel> active;
  List<IPOModel> closed;

  IpoList({
    required this.upcoming,
    required this.listed,
    required this.active,
    required this.closed,
  });

  factory IpoList.fromJson(Map<String, dynamic> json) => IpoList(
    upcoming: List<IPOModel>.from(
      json["upcoming"].map((x) => IPOModel.fromJson(x)),
    ),
    listed: List<IPOModel>.from(
      json["listed"].map((x) => IPOModel.fromJson(x)),
    ),
    active: List<IPOModel>.from(
      json["active"].map((x) => IPOModel.fromJson(x)),
    ),
    closed: List<IPOModel>.from(
      json["closed"].map((x) => IPOModel.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "upcoming": List<dynamic>.from(upcoming.map((x) => x.toJson())),
    "listed": List<dynamic>.from(listed.map((x) => x.toJson())),
    "active": List<dynamic>.from(active.map((x) => x.toJson())),
    "closed": List<dynamic>.from(closed.map((x) => x.toJson())),
  };
}

class IPOModel {
  final String symbol;
  final String name;
  final Status status;
  final bool isSme;
  final String additionalText;

  final double? minPrice;
  final double? maxPrice;
  final double? issuePrice;
  final double? listingGains;
  final double? listingPrice;

  final DateTime? biddingStartDate;
  final DateTime? biddingEndDate;
  final DateTime? listingDate;

  final int? lotSize;
  final String? documentUrl;

  final String? gmp;
  final String? sentiment;
  final String? confidence;

  IPOModel({
    required this.symbol,
    required this.name,
    required this.status,
    required this.isSme,
    required this.additionalText,
    this.minPrice,
    this.maxPrice,
    this.issuePrice,
    this.listingGains,
    this.listingPrice,
    this.biddingStartDate,
    this.biddingEndDate,
    this.listingDate,
    this.lotSize,
    this.documentUrl,
    
    this.gmp,
    this.sentiment,
    this.confidence,
  });

  // factory IPOModel.fromJson(Map<String, dynamic> json) {
  //   return IPOModel(
  //     symbol: json["symbol"] ?? "",
  //     name: json["name"] ?? "",
  //     status: statusValues.map[json["status"]] ?? Status.UPCOMING,
  //     isSme: json["is_sme"] ?? false,
  //     additionalText: json["additional_text"] ?? "",

  //     minPrice: _toDouble(json["min_price"]),
  //     maxPrice: _toDouble(json["max_price"]),
  //     issuePrice: _toDouble(json["issue_price"]),
  //     listingGains: _toDouble(json["listing_gains"]),
  //     listingPrice: _toDouble(json["listing_price"]),

  //     biddingStartDate: json["bidding_start_date"] != null
  //         ? DateTime.tryParse(json["bidding_start_date"])
  //         : null,

  //     biddingEndDate: json["bidding_end_date"] != null
  //         ? DateTime.tryParse(json["bidding_end_date"])
  //         : null,

  //     listingDate: json["listing_date"] != null
  //         ? DateTime.tryParse(json["listing_date"])
  //         : null,

  //     lotSize: _toInt(json["lot_size"]),
  //     documentUrl: json["document_url"],
  //   );
  // }
  factory IPOModel.fromJson(Map<String, dynamic> json) {
  return IPOModel(
    symbol: json["symbol"] ?? "",
    name: json["name"] ?? "",
    status: statusValues.map[json["status"]] ?? Status.UPCOMING,
    isSme: json["is_sme"] ?? false,
    additionalText: json["additional_text"] ?? "",

    minPrice: _toDouble(json["min_price"]),
    maxPrice: _toDouble(json["max_price"]),
    issuePrice: _toDouble(json["issue_price"]),
    listingGains: _toDouble(json["listing_gains"]),
    listingPrice: _toDouble(json["listing_price"]),

    biddingStartDate: json["bidding_start_date"] != null
        ? DateTime.tryParse(json["bidding_start_date"])
        : null,

    biddingEndDate: json["bidding_end_date"] != null
        ? DateTime.tryParse(json["bidding_end_date"])
        : null,

    listingDate: json["listing_date"] != null
        ? DateTime.tryParse(json["listing_date"])
        : null,

    lotSize: _toInt(json["lot_size"]),
    documentUrl: json["document_url"],

    // 🔥 ADD THESE
    gmp: json["gmp"],
    sentiment: json["sentiment"],
    confidence: json["confidence"],
  );
}


  // Map<String, dynamic> toJson() => {
  //   "symbol": symbol,
  //   "name": name,
  //   "status": statusValues.reverse[status],
  //   "is_sme": isSme,
  //   "additional_text": additionalText,
  //   "min_price": minPrice,
  //   "max_price": maxPrice,
  //   "issue_price": issuePrice,
  //   "listing_gains": listingGains,
  //   "listing_price": listingPrice,
  //   "bidding_start_date": biddingStartDate?.toIso8601String(),
  //   "bidding_end_date": biddingEndDate?.toIso8601String(),
  //   "listing_date": listingDate?.toIso8601String(),
  //   "lot_size": lotSize,
  //   "document_url": documentUrl,
  // };
  Map<String, dynamic> toJson() => {
  "symbol": symbol,
  "name": name,
  "status": statusValues.reverse[status],
  "is_sme": isSme,
  "additional_text": additionalText,
  "min_price": minPrice,
  "max_price": maxPrice,
  "issue_price": issuePrice,
  "listing_gains": listingGains,
  "listing_price": listingPrice,
  "bidding_start_date": biddingStartDate?.toIso8601String(),
  "bidding_end_date": biddingEndDate?.toIso8601String(),
  "listing_date": listingDate?.toIso8601String(),
  "lot_size": lotSize,
  "document_url": documentUrl,

  // 🔥 ADD THESE
  "gmp": gmp,
  "sentiment": sentiment,
  "confidence": confidence,
};


  IPOModel copyWith({
    String? gmp,
    String? sentiment,
    String? confidence,
    }) {
    return IPOModel(
      symbol: symbol,
      name: name,
      status: status,
      isSme: isSme,
      additionalText: additionalText,
      minPrice: minPrice,
      maxPrice: maxPrice,
      issuePrice: issuePrice,
      listingGains: listingGains,
      listingPrice: listingPrice,
      biddingStartDate: biddingStartDate,
      biddingEndDate: biddingEndDate,
      listingDate: listingDate,
      lotSize: lotSize,
      documentUrl: documentUrl,
      gmp: gmp ?? this.gmp,
      sentiment: sentiment ?? this.sentiment,
      confidence: confidence ?? this.confidence,
    );
  }
}

class IpoAIAnalysis {
  final String gmp;
  final String sentiment;
  final String confidence;

  IpoAIAnalysis({
    required this.gmp,
    required this.sentiment,
    required this.confidence,
  });

  factory IpoAIAnalysis.fromJson(Map<String, dynamic> json) {
    return IpoAIAnalysis(
       gmp: (json['gmp'] == null || json['gmp'] == 'Not available')
    ? '—'
    : json['gmp'],

      sentiment: json['sentiment'] ?? 'Neutral',
      confidence: json['confidence'] ?? 'Low',
    );
  }
}

enum Status { ACTIVE, CLOSED, LISTED, UPCOMING }

extension StatusX on Status {
  String get label {
    switch (this) {
      case Status.ACTIVE:
        return 'ACTIVE';
      case Status.CLOSED:
        return 'CLOSED';
      case Status.LISTED:
        return 'LISTED';
      case Status.UPCOMING:
        return 'UPCOMING';
    }
  }
}

final statusValues = EnumValues({
  "active": Status.ACTIVE,
  "closed": Status.CLOSED,
  "listed": Status.LISTED,
  "upcoming": Status.UPCOMING,
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
