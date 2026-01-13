import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/market_overview.dart';

class MarketRepository {
  List<double> _safeDoubleList(dynamic raw) {
  if (raw == null || raw is! List) return [];

  return raw
      .where((e) => e != null)
      .map((e) => (e as num).toDouble())
      .toList();
  }

  Future<MarketOverview> fetchMarketOverview() async {
    final url = Uri.parse(
      'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI?range=1d&interval=5m',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    final result = data['chart']?['result'];
    if (result == null || result.isEmpty) {
      throw Exception('Yahoo intraday data unavailable');
    }

    final quote = result[0]['indicators']?['quote']?[0];
    if (quote == null) {
      throw Exception('No quote data');
    }

    final opens = _safeDoubleList(quote['open']);
    final highs = _safeDoubleList(quote['high']);
    final lows = _safeDoubleList(quote['low']);
    final closes = _safeDoubleList(quote['close']);

    if (opens.isEmpty || highs.isEmpty || lows.isEmpty || closes.isEmpty) {
      return MarketOverview(
        bias: 'Market Closed',
        intradayHigh: 0,
        intradayLow: 0,
        buyAbove: 0,
        sellBelow: 0,
        note:
            'Market is closed today. Intraday levels will be available once trading starts.',
      );
    }


    final open = opens.first;
    final last = closes.last;
    final high = highs.reduce((a, b) => a > b ? a : b);
    final low = lows.reduce((a, b) => a < b ? a : b);

    String bias;
    if (last > open * 1.002) {
      bias = 'Bullish';
    } else if (last < open * 0.998) {
      bias = 'Bearish';
    } else {
      bias = 'Range-bound';
    }

    final range = high - low;
    final buyAbove = high - (range * 0.2);
    final sellBelow = low + (range * 0.2);

    String note;
    if (bias == 'Bullish') {
      note =
          'Bullish bias. Buy only above ${buyAbove.toStringAsFixed(0)}. Avoid shorts.';
    } else if (bias == 'Bearish') {
      note =
          'Bearish bias. Sell only below ${sellBelow.toStringAsFixed(0)}. Avoid longs.';
    } else {
      note =
          'Range-bound market. Trade only breakout above ${buyAbove.toStringAsFixed(0)} or breakdown below ${sellBelow.toStringAsFixed(0)}.';
    }

    return MarketOverview(
      bias: bias,
      intradayHigh: high,
      intradayLow: low,
      buyAbove: buyAbove,
      sellBelow: sellBelow,
      note: note,
    );
  }
}


