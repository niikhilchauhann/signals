
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum TrendDirection { bullish, bearish, neutral }

class PatternModel {
  final String id;
  final String title;
  final String description;
  final TrendDirection direction;
  // For Candlesticks: List of [Open, Close, Low, High] normalized 0-1
  final List<List<double>>? candleData; 
  // For Chart Patterns: List of Points (0-1 x, 0-1 y)
  final List<Offset>? chartPoints; 

  PatternModel({
    required this.id,
    required this.title,
    required this.description,
    required this.direction,
    this.candleData,
    this.chartPoints,
  });
}

// ==========================================
// 2. DATA LAYER (Repository)
// ==========================================

class PatternRepository {
  List<PatternModel> getCandlestickPatterns() {
    // Format: [Open, Close, Low, High] (0.0 to 1.0 relative height)
    return [
      PatternModel(id: 'c1', title: 'Hammer', description: 'Reversal signal at bottom.', direction: TrendDirection.bullish, candleData: [[0.6, 0.7, 0.2, 0.7]]),
      PatternModel(id: 'c2', title: 'Inv. Hammer', description: 'Bullish reversal warning.', direction: TrendDirection.bullish, candleData: [[0.3, 0.4, 0.3, 0.8]]),
      PatternModel(id: 'c3', title: 'Bullish Engulfing', description: 'Strong reversal move.', direction: TrendDirection.bullish, candleData: [[0.6, 0.4, 0.4, 0.6], [0.3, 0.7, 0.2, 0.8]]),
      PatternModel(id: 'c4', title: 'Bearish Engulfing', description: 'Top reversal signal.', direction: TrendDirection.bearish, candleData: [[0.3, 0.6, 0.3, 0.6], [0.7, 0.2, 0.2, 0.7]]),
      PatternModel(id: 'c5', title: 'Morning Star', description: 'Bottom reversal pattern.', direction: TrendDirection.bullish, candleData: [[0.8, 0.5, 0.5, 0.8], [0.4, 0.45, 0.35, 0.5], [0.5, 0.85, 0.5, 0.9]]),
      PatternModel(id: 'c6', title: 'Evening Star', description: 'Top reversal pattern.', direction: TrendDirection.bearish, candleData: [[0.2, 0.8, 0.2, 0.8], [0.85, 0.9, 0.85, 0.95], [0.8, 0.3, 0.3, 0.8]]),
      PatternModel(id: 'c7', title: 'Doji', description: 'Indecision in market.', direction: TrendDirection.neutral, candleData: [[0.5, 0.5, 0.2, 0.8]]),
      PatternModel(id: 'c8', title: 'Dragonfly Doji', description: 'Potential bullish reversal.', direction: TrendDirection.bullish, candleData: [[0.8, 0.8, 0.2, 0.8]]),
      PatternModel(id: 'c9', title: 'Gravestone Doji', description: 'Bearish reversal.', direction: TrendDirection.bearish, candleData: [[0.2, 0.2, 0.2, 0.8]]),
      PatternModel(id: 'c10', title: 'Marubozu (Bull)', description: 'Strong buying pressure.', direction: TrendDirection.bullish, candleData: [[0.1, 0.9, 0.1, 0.9]]),
      PatternModel(id: 'c11', title: 'Marubozu (Bear)', description: 'Strong selling pressure.', direction: TrendDirection.bearish, candleData: [[0.9, 0.1, 0.1, 0.9]]),
      PatternModel(id: 'c12', title: 'Spinning Top', description: 'Neutral / Indecision.', direction: TrendDirection.neutral, candleData: [[0.45, 0.55, 0.2, 0.8]]),
      PatternModel(id: 'c13', title: 'Three White Soldiers', description: 'Steady bullish advance.', direction: TrendDirection.bullish, candleData: [[0.2, 0.4, 0.2, 0.4], [0.4, 0.6, 0.4, 0.6], [0.6, 0.8, 0.6, 0.8]]),
      PatternModel(id: 'c14', title: 'Three Black Crows', description: 'Steady bearish decline.', direction: TrendDirection.bearish, candleData: [[0.8, 0.6, 0.6, 0.8], [0.6, 0.4, 0.4, 0.6], [0.4, 0.2, 0.2, 0.4]]),
      PatternModel(id: 'c15', title: 'Piercing Line', description: 'Bullish reversal.', direction: TrendDirection.bullish, candleData: [[0.8, 0.4, 0.4, 0.8], [0.3, 0.6, 0.2, 0.65]]),
    ];
  }

  List<PatternModel> getChartPatterns() {
    return [
      PatternModel(id: 'p1', title: 'Head & Shoulders', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.8), const Offset(0.2, 0.4), const Offset(0.3, 0.7), const Offset(0.5, 0.1), const Offset(0.7, 0.7), const Offset(0.8, 0.4), const Offset(1, 0.9)]),
      PatternModel(id: 'p2', title: 'Double Top', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.9), const Offset(0.3, 0.2), const Offset(0.5, 0.6), const Offset(0.7, 0.2), const Offset(1, 0.9)]),
      PatternModel(id: 'p3', title: 'Double Bottom', description: 'Reversal', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.1), const Offset(0.3, 0.8), const Offset(0.5, 0.4), const Offset(0.7, 0.8), const Offset(1, 0.1)]),
      PatternModel(id: 'p4', title: 'Cup & Handle', description: 'Continuation', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.1), const Offset(0.2, 0.7), const Offset(0.5, 0.8), const Offset(0.8, 0.7), const Offset(0.85, 0.6), const Offset(0.9, 0.65), const Offset(1, 0.4)]),
      PatternModel(id: 'p5', title: 'Ascending Triangle', description: 'Continuation', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.8), const Offset(0.3, 0.2), const Offset(0.5, 0.6), const Offset(0.7, 0.2), const Offset(0.9, 0.4), const Offset(1, 0.2)]),
      PatternModel(id: 'p6', title: 'Descending Triangle', description: 'Continuation', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.2), const Offset(0.3, 0.8), const Offset(0.5, 0.4), const Offset(0.7, 0.8), const Offset(0.9, 0.6), const Offset(1, 0.8)]),
      PatternModel(id: 'p7', title: 'Bull Flag', description: 'Continuation', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.9), const Offset(0.2, 0.2), const Offset(0.3, 0.4), const Offset(0.4, 0.3), const Offset(0.5, 0.5), const Offset(0.6, 0.4), const Offset(1, 0.1)]),
      PatternModel(id: 'p8', title: 'Bear Flag', description: 'Continuation', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.1), const Offset(0.2, 0.8), const Offset(0.3, 0.6), const Offset(0.4, 0.7), const Offset(0.5, 0.5), const Offset(0.6, 0.6), const Offset(1, 0.9)]),
      PatternModel(id: 'p9', title: 'Sym. Triangle', description: 'Bilateral', direction: TrendDirection.neutral, chartPoints: [const Offset(0, 0.5), const Offset(0.2, 0.1), const Offset(0.4, 0.8), const Offset(0.6, 0.3), const Offset(0.8, 0.6), const Offset(1, 0.5)]),
      PatternModel(id: 'p10', title: 'Falling Wedge', description: 'Reversal', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.1), const Offset(0.3, 0.7), const Offset(0.5, 0.5), const Offset(0.7, 0.8), const Offset(1, 0.3)]),
      PatternModel(id: 'p11', title: 'Rising Wedge', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.9), const Offset(0.3, 0.3), const Offset(0.5, 0.5), const Offset(0.7, 0.2), const Offset(1, 0.7)]),
      PatternModel(id: 'p12', title: 'Triple Top', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.8), const Offset(0.2, 0.2), const Offset(0.35, 0.6), const Offset(0.5, 0.2), const Offset(0.65, 0.6), const Offset(0.8, 0.2), const Offset(1, 0.8)]),
      PatternModel(id: 'p13', title: 'Triple Bottom', description: 'Reversal', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.2), const Offset(0.2, 0.8), const Offset(0.35, 0.4), const Offset(0.5, 0.8), const Offset(0.65, 0.4), const Offset(0.8, 0.8), const Offset(1, 0.2)]),
      PatternModel(id: 'p14', title: 'Rectangle', description: 'Consolidation', direction: TrendDirection.neutral, chartPoints: [const Offset(0, 0.5), const Offset(0.2, 0.2), const Offset(0.4, 0.8), const Offset(0.6, 0.2), const Offset(0.8, 0.8), const Offset(1, 0.5)]),
      PatternModel(id: 'p15', title: 'Diamond Top', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.5), const Offset(0.3, 0.1), const Offset(0.5, 0.5), const Offset(0.7, 0.9), const Offset(1, 0.5)]),
    ];
  }
}

// ==========================================
// 3. LOGIC LAYER (Providers)
// ==========================================

final patternRepositoryProvider = Provider((ref) => PatternRepository());

final candlestickPatternsProvider = Provider<List<PatternModel>>((ref) {
  return ref.watch(patternRepositoryProvider).getCandlestickPatterns();
});

final chartPatternsProvider = Provider<List<PatternModel>>((ref) {
  return ref.watch(patternRepositoryProvider).getChartPatterns();
});

// The index provider for the tabs
final yourActivitiesIndexProvider = StateProvider<int>((ref) => 0);
