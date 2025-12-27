
class IndianStockRaw {
  final String symbol;
  final String name;
  final double price;
  final double changePercent;
  final int volume;

  IndianStockRaw({
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent,
    required this.volume,
  });

factory IndianStockRaw.fromJson(Map<String, dynamic> json) {
  return IndianStockRaw(
    symbol: json['symbol']?.toString() ??
        json['stockSymbol']?.toString() ??
        '',
    name: json['companyName']?.toString() ??
        json['name']?.toString() ??
        '',
    price: (json['price'] ??
            json['lastPrice'] ??
            json['ltp'] ??
            0)
        .toDouble(),
    changePercent: (json['percentChange'] ??
            json['changePercent'] ??
            json['pChange'] ??
            0)
        .toDouble(),
    volume: (json['volume'] ??
            json['totalTradedVolume'] ??
            0)
        .toInt(),
  );
}

}
