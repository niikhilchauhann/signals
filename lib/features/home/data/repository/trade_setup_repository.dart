import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../algorithm_engine/data/models/uni_stock_model.dart';
import '../../../algorithm_engine/data/repository/stock_repository.dart';
// import '../models/trade_analyzer.dart';
import '../models/trade_setup_model.dart';

class TradeRepository {
  final _marketRepo = StockRepository();

  Future<List<TradeSetup>> searchTradeAnalysis({
    String symbol = 'KALYANKJIL.NS',
  }) async {
    final url = Uri.parse(
      'https://query1.finance.yahoo.com/v8/finance/chart/$symbol?range=6mo&interval=1h',
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
        name: 'Kalyan Jewellers',
        symbol: "KALYANKJIL",
        score: 82,
        horizon: "1–2 Weeks",
        verdict: TradeVerdict.avoid,
        signals: "RSI oversold (${rsi14.toStringAsFixed(1)}), Volume spike",
      ),
    ];
  }

  Future<TradeSetup?> _analyzeStock(String symbol, String name) async {
    final url = Uri.parse(
      'https://query1.finance.yahoo.com/v8/finance/chart/$symbol?range=6mo&interval=1h',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    // ✅ HARD GUARD — THIS FIXES EVERYTHING
    final result = data['chart']?['result'];
    if (result == null || result.isEmpty) {
      debugPrint("⚠️ Skipping $symbol (no Yahoo data)");
      return null;
    }

    final indicators = result[0]['indicators']?['quote'];
    if (indicators == null || indicators.isEmpty) {
      debugPrint("⚠️ Skipping $symbol (missing OHLC)");
      return null;
    }

    final quote = indicators[0];

    final closesRaw = quote['close'];
    final volumesRaw = quote['volume'];

    if (closesRaw == null || volumesRaw == null) {
      if (closesRaw == null || volumesRaw == null) {
        debugPrint("⚠️ Skipping $symbol (missing OHLC)");
        return null;
      }
    }

    final closes = (closesRaw as List)
        .where((e) => e != null)
        .map((e) => (e as num).toDouble())
        .toList();

    final volumes = (volumesRaw as List)
        .where((e) => e != null)
        .map((e) => (e as num).toInt())
        .toList();

    if (closes.length < 50 || volumes.length < 50) {
      return TradeSetup(
        name: name,
        symbol: symbol.replaceAll('.NS', ''),
        score: 40,
        horizon: 'N/A',
        signals: 'Insufficient data',
        verdict: TradeVerdict.avoid,
      );
    }

    // RSI
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
    final rsi = 100 - (100 / (1 + rs));

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

    final verdict = score >= 75
        ? TradeVerdict.buy
        : score >= 55
        ? TradeVerdict.watch
        : TradeVerdict.avoid;

    return TradeSetup(
      name: name,
      symbol: symbol.replaceAll('.NS', ''),
      score: score,
      horizon: '1–2 Weeks',
      signals:
          'RSI ${rsi.toStringAsFixed(1)}, Support ${support.toStringAsFixed(0)}, Volume ${volSpike ? 'High' : 'Normal'}',
      verdict: verdict,
    );
  }

  TradeSetup _fallbackIndianApiAnalysis(StockModel s) {
    double parse(String v) => double.tryParse(v) ?? 0;

    final price = parse(s.price);
    final high = parse(s.high);
    final low = parse(s.low);
    final open = parse(s.open);
    final change = parse(s.netChange);
    final pct = parse(s.percentChange.replaceAll('%', ''));

    int score = 50;
    final List<String> signals = [];

    // Momentum
    if (change > 0) {
      score += 10;
      signals.add('Positive momentum');
    } else {
      score -= 5;
      signals.add('Negative momentum');
    }

    // Intraday strength
    if (price > open) {
      score += 10;
      signals.add('Above open');
    }

    // Near day low / high logic
    if (low > 0 && price <= low * 1.02) {
      score += 10;
      signals.add('Near day low');
    }

    if (high > 0 && price >= high * 0.98) {
      score += 10;
      signals.add('Near day high');
    }

    // Trend labels from API
    if (s.shortTermTrends.toLowerCase().contains('bullish')) {
      score += 10;
      signals.add('Bullish short-term trend');
    }

    if (s.longTermTrends.toLowerCase().contains('bullish')) {
      score += 5;
      signals.add('Bullish long-term trend');
    }

    final verdict = score >= 70
        ? TradeVerdict.buy
        : score >= 55
        ? TradeVerdict.watch
        : TradeVerdict.avoid;

    return TradeSetup(
      name: s.companyName,
      symbol: s.tickerId,
      score: score.clamp(0, 100),
      horizon: 'Intraday–Swing',
      verdict: verdict,
      signals: signals.join(', '),
    );
  }

  String? normalizeYahooSymbol(String raw) {
    if (raw.isEmpty) return null;

    if (raw.startsWith('S000')) return null;

    if (raw.endsWith('.NS') || raw.endsWith('.BO')) {
      return raw;
    }

    if (raw.length <= 10 && RegExp(r'^[A-Z]+$').hasMatch(raw)) {
      return '$raw.NS';
    }

    return null;
  }

  Future<List<TradeSetup>> fetchTopTrades() async {
    final Map<String, TradeSetup> sets = {};

    // Future<void> collectStocks(List<StockModel> list) async {
    //   print(list);

    //   for (final s in list) {
    //     final yahooSymbol = normalizeYahooSymbol(s.tickerId);
    //     if (yahooSymbol == null) continue;

    //     try {
    //       final trade = await _analyzeStock(yahooSymbol);
    //       if (trade == null) continue;
    //       sets[trade.symbol] = trade;
    //     } catch (e, st) {
    //       print(e);
    //       print(st);
    //     }
    //   }
    // }
    Future<void> collectStocks(List<StockModel> list) async {
      for (final s in list) {
        final yahooSymbol = normalizeYahooSymbol(s.tickerId);

        // 1️⃣ Try Yahoo if symbol is valid
        if (yahooSymbol != null) {
          try {
            final trade = await _analyzeStock(yahooSymbol, s.companyName);
            if (trade != null) {
              sets[trade.symbol] = trade;
              continue; // ✅ Yahoo success, skip fallback
            }
          } catch (e, st) {
            debugPrint(e.toString());
            debugPrint(st.toString());

            // fall through to fallback
          }
        }

        // 2️⃣ Fallback to IndianAPI snapshot analysis
        final fallback = _fallbackIndianApiAnalysis(s);
        sets[fallback.symbol] = fallback;
      }
    }

    await collectStocks(
      (await _marketRepo.fetchTrendingStocks()).trendingStocks.topGainers,
    );
    await collectStocks(await _marketRepo.fetchNseMostActiveStocks());
    await collectStocks(await _marketRepo.fetchBseMostActiveStocks());

    if (sets.isEmpty) {
      return [
        TradeSetup(
          name: 'NSE',
          symbol: 'NIFTY 50',
          score: 50,
          horizon: 'Intraday',
          signals: 'No strong technical edge today',
          verdict: TradeVerdict.watch,
        ),
      ];
    }

    final result = sets.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return result;
  }
}
