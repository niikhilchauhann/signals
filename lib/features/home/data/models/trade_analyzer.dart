import '../models/trade_model.dart';
import 'indian_market_model.dart';

class TradeAnalyzer {
  TradeSetup analyze(IndianStockRaw s) {
    int score = 50;

    if (s.changePercent > 3) score += 15;
    if (s.changePercent > 6) score += 10;
    if (s.volume > 1_000_000) score += 10;

    TradeVerdict verdict;
    if (score >= 75) {
      verdict = TradeVerdict.buy;
    } else if (score >= 55) {
      verdict = TradeVerdict.watch;
    } else {
      verdict = TradeVerdict.avoid;
    }

    return TradeSetup(
      symbol: s.symbol,
      score: score,
      horizon: '1–5 Days',
      signals:
          'Δ ${s.changePercent.toStringAsFixed(2)}%, Vol ${s.volume}',
      verdict: verdict,
    );
  }
}
