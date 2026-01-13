enum TradeVerdict { buy, watch, avoid }

enum TradeSource { technical, fallback }

class TradeSetup {
  final String name;
  final String symbol;
  final int score;
  final String horizon;
  final String signals;
  final TradeVerdict verdict;
  final TradeSource source;

  TradeSetup({
    required this.name,
    required this.symbol,
    required this.score,
    required this.horizon,
    required this.signals,
    required this.verdict,
    this.source = TradeSource.technical,
  });
}
