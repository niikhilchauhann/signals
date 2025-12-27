enum TradeVerdict { buy, watch, avoid }

class TradeSetup {
  final String symbol;
  final int score;
  final String horizon;
  final String signals;
  final TradeVerdict verdict;

  TradeSetup({
    required this.symbol,
    required this.score,
    required this.horizon,
    required this.signals,
    required this.verdict,
  });
}
