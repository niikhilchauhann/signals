// To parse this JSON data, do
//
//     final ipoList = ipoListFromJson(jsonString);

import 'dart:convert';

IpoList ipoListFromJson(String str) => IpoList.fromJson(json.decode(str));

String ipoListToJson(IpoList data) => json.encode(data.toJson());

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
        upcoming: List<IPOModel>.from(json["upcoming"].map((x) => IPOModel.fromJson(x))),
        listed: List<IPOModel>.from(json["listed"].map((x) => IPOModel.fromJson(x))),
        active: List<IPOModel>.from(json["active"].map((x) => IPOModel.fromJson(x))),
        closed: List<IPOModel>.from(json["closed"].map((x) => IPOModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "upcoming": List<dynamic>.from(upcoming.map((x) => x.toJson())),
        "listed": List<dynamic>.from(listed.map((x) => x.toJson())),
        "active": List<dynamic>.from(active.map((x) => x.toJson())),
        "closed": List<dynamic>.from(closed.map((x) => x.toJson())),
    };
}

class IPOModel {
    String symbol;
    String name;
    Status status;
    bool isSme;
    String additionalText;
    int? minPrice;
    int? maxPrice;
    int? issuePrice;
    double? listingGains;
    double? listingPrice;
    DateTime? biddingStartDate;
    DateTime? biddingEndDate;
    DateTime? listingDate;
    int? lotSize;
    String? documentUrl;

    IPOModel({
        required this.symbol,
        required this.name,
        required this.status,
        required this.isSme,
        required this.additionalText,
        required this.minPrice,
        required this.maxPrice,
        required this.issuePrice,
        required this.listingGains,
        required this.listingPrice,
        required this.biddingStartDate,
        required this.biddingEndDate,
        required this.listingDate,
        required this.lotSize,
        required this.documentUrl,
    });

    factory IPOModel.fromJson(Map<String, dynamic> json) => IPOModel(
        symbol: json["symbol"],
        name: json["name"],
        status: statusValues.map[json["status"]]!,
        isSme: json["is_sme"],
        additionalText: json["additional_text"],
        minPrice: json["min_price"],
        maxPrice: json["max_price"],
        issuePrice: json["issue_price"],
        listingGains: json["listing_gains"]?.toDouble(),
        listingPrice: json["listing_price"]?.toDouble(),
        biddingStartDate: json["bidding_start_date"] == null ? null : DateTime.parse(json["bidding_start_date"]),
        biddingEndDate: json["bidding_end_date"] == null ? null : DateTime.parse(json["bidding_end_date"]),
        listingDate: json["listing_date"] == null ? null : DateTime.parse(json["listing_date"]),
        lotSize: json["lot_size"],
        documentUrl: json["document_url"],
    );

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
        "bidding_start_date": "${biddingStartDate!.year.toString().padLeft(4, '0')}-${biddingStartDate!.month.toString().padLeft(2, '0')}-${biddingStartDate!.day.toString().padLeft(2, '0')}",
        "bidding_end_date": "${biddingEndDate!.year.toString().padLeft(4, '0')}-${biddingEndDate!.month.toString().padLeft(2, '0')}-${biddingEndDate!.day.toString().padLeft(2, '0')}",
        "listing_date": "${listingDate!.year.toString().padLeft(4, '0')}-${listingDate!.month.toString().padLeft(2, '0')}-${listingDate!.day.toString().padLeft(2, '0')}",
        "lot_size": lotSize,
        "document_url": documentUrl,
    };
}

enum Status {
    ACTIVE,
    CLOSED,
    LISTED,
    UPCOMING
}

final statusValues = EnumValues({
    "active": Status.ACTIVE,
    "closed": Status.CLOSED,
    "listed": Status.LISTED,
    "upcoming": Status.UPCOMING
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
