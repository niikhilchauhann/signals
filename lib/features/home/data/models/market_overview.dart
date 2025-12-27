class MarketOverview {
  final String bias; // Bullish / Bearish / Range-bound
  final double intradayHigh;
  final double intradayLow;
  final double buyAbove;
  final double sellBelow;
  final String note;

  MarketOverview({
    required this.bias,
    required this.intradayHigh,
    required this.intradayLow,
    required this.buyAbove,
    required this.sellBelow,
    required this.note,
  });
}
