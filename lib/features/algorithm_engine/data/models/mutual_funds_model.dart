// To parse this JSON data, do
//
//     final mutualFunds = mutualFundsFromJson(jsonString);

import 'dart:convert';

MutualFunds mutualFundsFromJson(String str) => MutualFunds.fromJson(json.decode(str));

String mutualFundsToJson(MutualFunds data) => json.encode(data.toJson());

class MutualFunds {
    Map<String, List<Debt>> debt;
    SolutionsOriented solutionsOriented;
    Map<String, List<Debt>> equity;
    Hybrid hybrid;
    GlobalFundOfFunds globalFundOfFunds;
    IndexFunds indexFunds;
    Other other;

    MutualFunds({
        required this.debt,
        required this.solutionsOriented,
        required this.equity,
        required this.hybrid,
        required this.globalFundOfFunds,
        required this.indexFunds,
        required this.other,
    });

    factory MutualFunds.fromJson(Map<String, dynamic> json) => MutualFunds(
        debt: Map.from(json["Debt"]).map((k, v) => MapEntry<String, List<Debt>>(k, List<Debt>.from(v.map((x) => Debt.fromJson(x))))),
        solutionsOriented: SolutionsOriented.fromJson(json["Solutions Oriented"]),
        equity: Map.from(json["Equity"]).map((k, v) => MapEntry<String, List<Debt>>(k, List<Debt>.from(v.map((x) => Debt.fromJson(x))))),
        hybrid: Hybrid.fromJson(json["Hybrid"]),
        globalFundOfFunds: GlobalFundOfFunds.fromJson(json["Global Fund of Funds"]),
        indexFunds: IndexFunds.fromJson(json["Index Funds"]),
        other: Other.fromJson(json["Other"]),
    );

    Map<String, dynamic> toJson() => {
        "Debt": Map.from(debt).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "Solutions Oriented": solutionsOriented.toJson(),
        "Equity": Map.from(equity).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "Hybrid": hybrid.toJson(),
        "Global Fund of Funds": globalFundOfFunds.toJson(),
        "Index Funds": indexFunds.toJson(),
        "Other": other.toJson(),
    };
}

class Debt {
    String fundName;
    double latestNav;
    double percentageChange;
    double assetSize;
    double the1MonthReturn;
    double the3MonthReturn;
    double the6MonthReturn;
    double the1YearReturn;
    double? the3YearReturn;
    double? the5YearReturn;
    int? starRating;

    Debt({
        required this.fundName,
        required this.latestNav,
        required this.percentageChange,
        required this.assetSize,
        required this.the1MonthReturn,
        required this.the3MonthReturn,
        required this.the6MonthReturn,
        required this.the1YearReturn,
        required this.the3YearReturn,
        required this.the5YearReturn,
        required this.starRating,
    });

    factory Debt.fromJson(Map<String, dynamic> json) => Debt(
        fundName: json["fund_name"],
        latestNav: json["latest_nav"]?.toDouble(),
        percentageChange: json["percentage_change"]?.toDouble(),
        assetSize: json["asset_size"]?.toDouble(),
        the1MonthReturn: json["1_month_return"]?.toDouble(),
        the3MonthReturn: json["3_month_return"]?.toDouble(),
        the6MonthReturn: json["6_month_return"]?.toDouble(),
        the1YearReturn: json["1_year_return"]?.toDouble(),
        the3YearReturn: json["3_year_return"]?.toDouble(),
        the5YearReturn: json["5_year_return"]?.toDouble(),
        starRating: json["star_rating"],
    );

    Map<String, dynamic> toJson() => {
        "fund_name": fundName,
        "latest_nav": latestNav,
        "percentage_change": percentageChange,
        "asset_size": assetSize,
        "1_month_return": the1MonthReturn,
        "3_month_return": the3MonthReturn,
        "6_month_return": the6MonthReturn,
        "1_year_return": the1YearReturn,
        "3_year_return": the3YearReturn,
        "5_year_return": the5YearReturn,
        "star_rating": starRating,
    };
}

class GlobalFundOfFunds {
    List<Debt> globalOther;

    GlobalFundOfFunds({
        required this.globalOther,
    });

    factory GlobalFundOfFunds.fromJson(Map<String, dynamic> json) => GlobalFundOfFunds(
        globalOther: List<Debt>.from(json["Global - Other"].map((x) => Debt.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Global - Other": List<dynamic>.from(globalOther.map((x) => x.toJson())),
    };
}

class Hybrid {
    List<Debt> fundOfFunds;
    List<Debt> multiAssetAllocation;
    List<Debt> equitySavings;
    List<Debt> balancedAllocation;
    List<Debt> dynamicAssetAllocation;
    List<Debt> aggressiveAllocation;
    List<Debt> conservativeAllocation;

    Hybrid({
        required this.fundOfFunds,
        required this.multiAssetAllocation,
        required this.equitySavings,
        required this.balancedAllocation,
        required this.dynamicAssetAllocation,
        required this.aggressiveAllocation,
        required this.conservativeAllocation,
    });

    factory Hybrid.fromJson(Map<String, dynamic> json) => Hybrid(
        fundOfFunds: List<Debt>.from(json["Fund of Funds"].map((x) => Debt.fromJson(x))),
        multiAssetAllocation: List<Debt>.from(json["Multi Asset Allocation"].map((x) => Debt.fromJson(x))),
        equitySavings: List<Debt>.from(json["Equity Savings"].map((x) => Debt.fromJson(x))),
        balancedAllocation: List<Debt>.from(json["Balanced Allocation"].map((x) => Debt.fromJson(x))),
        dynamicAssetAllocation: List<Debt>.from(json["Dynamic Asset Allocation"].map((x) => Debt.fromJson(x))),
        aggressiveAllocation: List<Debt>.from(json["Aggressive Allocation"].map((x) => Debt.fromJson(x))),
        conservativeAllocation: List<Debt>.from(json["Conservative Allocation"].map((x) => Debt.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Fund of Funds": List<dynamic>.from(fundOfFunds.map((x) => x.toJson())),
        "Multi Asset Allocation": List<dynamic>.from(multiAssetAllocation.map((x) => x.toJson())),
        "Equity Savings": List<dynamic>.from(equitySavings.map((x) => x.toJson())),
        "Balanced Allocation": List<dynamic>.from(balancedAllocation.map((x) => x.toJson())),
        "Dynamic Asset Allocation": List<dynamic>.from(dynamicAssetAllocation.map((x) => x.toJson())),
        "Aggressive Allocation": List<dynamic>.from(aggressiveAllocation.map((x) => x.toJson())),
        "Conservative Allocation": List<dynamic>.from(conservativeAllocation.map((x) => x.toJson())),
    };
}

class IndexFunds {
    List<Debt> indexFunds;

    IndexFunds({
        required this.indexFunds,
    });

    factory IndexFunds.fromJson(Map<String, dynamic> json) => IndexFunds(
        indexFunds: List<Debt>.from(json["Index Funds"].map((x) => Debt.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Index Funds": List<dynamic>.from(indexFunds.map((x) => x.toJson())),
    };
}

class Other {
    List<Debt> indexFundsFixedIncome;
    List<Debt> liquid;
    List<Debt> overnight;
    List<Debt> arbitrageFund;

    Other({
        required this.indexFundsFixedIncome,
        required this.liquid,
        required this.overnight,
        required this.arbitrageFund,
    });

    factory Other.fromJson(Map<String, dynamic> json) => Other(
        indexFundsFixedIncome: List<Debt>.from(json["Index Funds - Fixed Income"].map((x) => Debt.fromJson(x))),
        liquid: List<Debt>.from(json["Liquid"].map((x) => Debt.fromJson(x))),
        overnight: List<Debt>.from(json["Overnight"].map((x) => Debt.fromJson(x))),
        arbitrageFund: List<Debt>.from(json["Arbitrage Fund"].map((x) => Debt.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Index Funds - Fixed Income": List<dynamic>.from(indexFundsFixedIncome.map((x) => x.toJson())),
        "Liquid": List<dynamic>.from(liquid.map((x) => x.toJson())),
        "Overnight": List<dynamic>.from(overnight.map((x) => x.toJson())),
        "Arbitrage Fund": List<dynamic>.from(arbitrageFund.map((x) => x.toJson())),
    };
}

class SolutionsOriented {
    List<Debt> children;
    List<Debt> retirement;

    SolutionsOriented({
        required this.children,
        required this.retirement,
    });

    factory SolutionsOriented.fromJson(Map<String, dynamic> json) => SolutionsOriented(
        children: List<Debt>.from(json["Children"].map((x) => Debt.fromJson(x))),
        retirement: List<Debt>.from(json["Retirement"].map((x) => Debt.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Children": List<dynamic>.from(children.map((x) => x.toJson())),
        "Retirement": List<dynamic>.from(retirement.map((x) => x.toJson())),
    };
}
