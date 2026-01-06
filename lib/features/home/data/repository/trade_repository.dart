import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../algorithm_engine/data/repository/stock_repository.dart';
import '../models/trade_analyzer.dart';
import '../models/trade_model.dart';

class TradeRepository {
  final _marketRepo = StockRepository();
  final _analyzer = TradeAnalyzer();

  Future<List<TradeSetup>> searchTradeAnalysis({String symbol = 'KALYANKJIL.NS'}) async {
    final url = Uri.parse(
      'https://query1.finance.yahoo.com/v8/finance/chart/$symbol?range=6mo&interval=1d',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    final quote = data['chart']['result'][0]['indicators']['quote'][0];

    final List<double> closes = (quote['close'] as List)
        .where((e) => e != null)
        .map((e) => (e as num).toDouble())
        .toList();

    final List<int> volumes = (quote['volume'] as List)
        .where((e) => e != null)
        .map((e) => (e as num).toInt())
        .toList();

    double rsi(List<double> prices, int period) {
      double gain = 0, loss = 0;
      if (prices.length < 50) {
        throw Exception('Not enough data');
      }

      for (int i = prices.length - period - 1; i < prices.length - 1; i++) {
        final diff = prices[i + 1] - prices[i];
        if (diff > 0) {
          gain += diff;
        } else {
          loss -= diff;
        }
      }

      final rs = loss == 0 ? 0 : gain / loss;
      return 100 - (100 / (1 + rs));
    }

    final rsi14 = rsi(closes, 14);
    final lastClose = closes.last;

    final support = closes
        .sublist(closes.length - 15)
        .reduce((double a, double b) => a < b ? a : b);

    final avgVol =
        volumes.sublist(volumes.length - 20).reduce((int a, int b) => a + b) /
        20;

    final volumeSpike = volumes.last > avgVol * 1.5;

    final isBuy = rsi14 < 35 && lastClose <= support * 1.05 && volumeSpike;

    if (!isBuy) return [];

    return [
      TradeSetup(
        symbol: "KALYANKJIL",
        score: 82,
        horizon: "1–2 Weeks",
        verdict: TradeVerdict.avoid,
        signals: "RSI oversold (${rsi14.toStringAsFixed(1)}), Volume spike",
      ),
    ];
  }

  Future<TradeSetup> _analyzeStock(String symbol) async {
    final url = Uri.parse(
      'https://query1.finance.yahoo.com/v8/finance/chart/$symbol?range=6mo&interval=1d',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    final quote = data['chart']['result'][0]['indicators']['quote'][0];

    final closes = (quote['close'] as List)
        .where((e) => e != null)
        .map((e) => (e as num).toDouble())
        .toList();

    final volumes = (quote['volume'] as List)
        .where((e) => e != null)
        .map((e) => (e as num).toInt())
        .toList();

    if (closes.length < 50) {
      return TradeSetup(
        symbol: symbol.replaceAll('.NS', ''),
        score: 40,
        horizon: 'N/A',
        signals: 'Insufficient data',
        verdict: TradeVerdict.avoid,
      );
    }

    double rsi14() {
      double gain = 0, loss = 0;
      for (int i = closes.length - 15; i < closes.length - 1; i++) {
        final diff = closes[i + 1] - closes[i];
        if (diff > 0) {
          gain += diff;
        } else {
          loss -= diff;
        }
      }
      final rs = loss == 0 ? 0 : gain / loss;
      return 100 - (100 / (1 + rs));
    }

    final rsi = rsi14();
    final last = closes.last;

    final support = closes
        .sublist(closes.length - 20)
        .reduce((a, b) => a < b ? a : b);

    final avgVol =
        volumes.sublist(volumes.length - 20).reduce((a, b) => a + b) / 20;

    final volSpike = volumes.last > avgVol * 1.3;

    int score = 50;
    if (rsi < 30) score += 20;
    if (last <= support * 1.05) score += 15;
    if (volSpike) score += 15;

    TradeVerdict verdict;
    if (score >= 75) {
      verdict = TradeVerdict.buy;
    } else if (score >= 55) {
      verdict = TradeVerdict.watch;
    } else {
      verdict = TradeVerdict.avoid;
    }

    return TradeSetup(
      symbol: symbol.replaceAll('.NS', ''),
      score: score,
      horizon: '1–2 Weeks',
      signals:
          'RSI ${rsi.toStringAsFixed(1)}, Support ${support.toStringAsFixed(0)}, Volume ${volSpike ? 'High' : 'Normal'}',
      verdict: verdict,
    );
  }

  Future<List<TradeSetup>> fetchTopTrades() async {
    final sets = <String, TradeSetup>{};

    Future<void> collect(List<dynamic> list) async {
      for (final s in list) {
        final trade = _analyzer.analyze(s);
        sets[trade.symbol] = trade;
      }
    }

    // await collect(await _marketRepo.fetchTrendingStocks());
    // await collect(await _marketRepo.fetchNseMostActiveStocks());
    // await collect(await _marketRepo.fetchBseMostActiveStocks());
    // await collect(await _marketRepo.fetchPriceShockers());
    // await collect(await _marketRepo.fetchWeek52Data());

    if (sets.isEmpty) {
      return [
        TradeSetup(
          symbol: 'NIFTY',
          score: 50,
          horizon: 'Intraday',
          signals: 'Market closed / data delayed',
          verdict: TradeVerdict.watch,
        ),
      ];
    }

    final result = sets.values.toList();
    result.sort((a, b) => b.score.compareTo(a.score));
    return result;
  }
}