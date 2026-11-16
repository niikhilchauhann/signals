

import 'package:flutter/material.dart';
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
  // Extended fields for Learn Charts screen
  final String? detailedDescription;
  final List<String>? tradingTips;
  final List<String>? commonMistakes;
  final int? successProbability;

  PatternModel({
    required this.id,
    required this.title,
    required this.description,
    required this.direction,
    this.candleData,
    this.chartPoints,
    this.detailedDescription,
    this.tradingTips,
    this.commonMistakes,
    this.successProbability,
  });
}

// ==========================================
// Article Model for Learning Hub
// ==========================================

enum Difficulty { beginner, intermediate, advanced }

class ArticleModel {
  final String id;
  final String title;
  final String subtitle;
  final int readingTimeMinutes;
  final Difficulty difficulty;
  final IconData icon;
  final String category;
  final List<ArticleSection> sections;

  ArticleModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.readingTimeMinutes,
    required this.difficulty,
    required this.icon,
    required this.category,
    required this.sections,
  });
}

class ArticleSection {
  final String heading;
  final String body;

  ArticleSection({required this.heading, required this.body});
}

class ArticleCategory {
  final String name;
  final String subtitle;
  final IconData icon;
  final int articleCount;

  ArticleCategory({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.articleCount,
  });
}

// ==========================================
// 2. DATA LAYER (Repository)
// ==========================================

class PatternRepository {
  List<PatternModel> getCandlestickPatterns() {
    return [
      PatternModel(id: 'c1', title: 'Hammer', description: 'Reversal signal at bottom.', direction: TrendDirection.bullish, candleData: [[0.6, 0.7, 0.2, 0.7]], detailedDescription: 'The Hammer is a single candlestick pattern that appears at the bottom of a downtrend. It has a small body near the top and a long lower shadow at least twice the size of the body. This pattern suggests that sellers pushed prices lower during the session, but buyers regained control, pushing the price back up.', tradingTips: ['Look for confirmation with a bullish candle the next day', 'Works best at established support levels', 'Higher volume increases reliability'], commonMistakes: ['Trading without confirmation', 'Ignoring the overall trend context', 'Confusing with a hanging man in an uptrend'], successProbability: 60),
      PatternModel(id: 'c2', title: 'Inv. Hammer', description: 'Bullish reversal warning.', direction: TrendDirection.bullish, candleData: [[0.3, 0.4, 0.3, 0.8]], detailedDescription: 'The Inverted Hammer appears at the bottom of downtrends. It has a small body near the low and a long upper shadow. Despite initial selling pressure, buyers attempted to push prices higher, indicating potential reversal.', tradingTips: ['Wait for next-day bullish confirmation', 'Best when found near support zones'], commonMistakes: ['Entering without confirmation candle'], successProbability: 55),
      PatternModel(id: 'c3', title: 'Bullish Engulfing', description: 'Strong reversal move.', direction: TrendDirection.bullish, candleData: [[0.6, 0.4, 0.4, 0.6], [0.3, 0.7, 0.2, 0.8]], detailedDescription: 'A two-candle pattern where a large bullish candle completely engulfs the previous bearish candle. This shows a decisive shift from selling to buying pressure.', tradingTips: ['More reliable at key support levels', 'Volume should increase on the engulfing day', 'Entry near the close of the engulfing candle'], commonMistakes: ['Ignoring if the engulfing body is too small', 'Not checking volume'], successProbability: 63),
      PatternModel(id: 'c4', title: 'Bearish Engulfing', description: 'Top reversal signal.', direction: TrendDirection.bearish, candleData: [[0.3, 0.6, 0.3, 0.6], [0.7, 0.2, 0.2, 0.7]], detailedDescription: 'A large bearish candle completely engulfs the previous bullish candle, signaling a shift from buying to selling pressure at the top of an uptrend.', tradingTips: ['Best at resistance zones', 'Confirm with next-day bearish follow-through'], commonMistakes: ['Trading in the middle of a range'], successProbability: 62),
      PatternModel(id: 'c5', title: 'Morning Star', description: 'Bottom reversal pattern.', direction: TrendDirection.bullish, candleData: [[0.8, 0.5, 0.5, 0.8], [0.4, 0.45, 0.35, 0.5], [0.5, 0.85, 0.5, 0.9]], detailedDescription: 'A three-candle pattern: a bearish candle, followed by a small-bodied candle (indecision), then a strong bullish candle. Signals a bottom reversal.', tradingTips: ['The third candle should close above the midpoint of the first', 'Gap between candles increases reliability'], commonMistakes: ['Not waiting for the third candle to complete'], successProbability: 68),
      PatternModel(id: 'c6', title: 'Evening Star', description: 'Top reversal pattern.', direction: TrendDirection.bearish, candleData: [[0.2, 0.8, 0.2, 0.8], [0.85, 0.9, 0.85, 0.95], [0.8, 0.3, 0.3, 0.8]], detailedDescription: 'Opposite of the Morning Star. Appears at the top of uptrends: bullish candle, small indecision candle, then strong bearish candle.', tradingTips: ['Best at established resistance', 'Volume spike on the third candle confirms'], commonMistakes: ['Ignoring overall market trend'], successProbability: 67),
      PatternModel(id: 'c7', title: 'Doji', description: 'Indecision in market.', direction: TrendDirection.neutral, candleData: [[0.5, 0.5, 0.2, 0.8]], detailedDescription: 'A candle where open and close are virtually equal, creating a cross shape. Represents indecision between buyers and sellers.', tradingTips: ['Context matters — look at surrounding candles', 'At extremes of trends, signals potential reversal'], commonMistakes: ['Trading doji in isolation without context'], successProbability: 50),
      PatternModel(id: 'c8', title: 'Dragonfly Doji', description: 'Potential bullish reversal.', direction: TrendDirection.bullish, candleData: [[0.8, 0.8, 0.2, 0.8]], successProbability: 55),
      PatternModel(id: 'c9', title: 'Gravestone Doji', description: 'Bearish reversal.', direction: TrendDirection.bearish, candleData: [[0.2, 0.2, 0.2, 0.8]], successProbability: 55),
      PatternModel(id: 'c10', title: 'Marubozu (Bull)', description: 'Strong buying pressure.', direction: TrendDirection.bullish, candleData: [[0.1, 0.9, 0.1, 0.9]], successProbability: 70),
      PatternModel(id: 'c11', title: 'Marubozu (Bear)', description: 'Strong selling pressure.', direction: TrendDirection.bearish, candleData: [[0.9, 0.1, 0.1, 0.9]], successProbability: 70),
      PatternModel(id: 'c12', title: 'Spinning Top', description: 'Neutral / Indecision.', direction: TrendDirection.neutral, candleData: [[0.45, 0.55, 0.2, 0.8]], successProbability: 45),
      PatternModel(id: 'c13', title: 'Three White Soldiers', description: 'Steady bullish advance.', direction: TrendDirection.bullish, candleData: [[0.2, 0.4, 0.2, 0.4], [0.4, 0.6, 0.4, 0.6], [0.6, 0.8, 0.6, 0.8]], successProbability: 72),
      PatternModel(id: 'c14', title: 'Three Black Crows', description: 'Steady bearish decline.', direction: TrendDirection.bearish, candleData: [[0.8, 0.6, 0.6, 0.8], [0.6, 0.4, 0.4, 0.6], [0.4, 0.2, 0.2, 0.4]], successProbability: 72),
      PatternModel(id: 'c15', title: 'Piercing Line', description: 'Bullish reversal.', direction: TrendDirection.bullish, candleData: [[0.8, 0.4, 0.4, 0.8], [0.3, 0.6, 0.2, 0.65]], successProbability: 60),
    ];
  }

  List<PatternModel> getChartPatterns() {
    return [
      PatternModel(id: 'p1', title: 'Head & Shoulders', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.8), const Offset(0.2, 0.4), const Offset(0.3, 0.7), const Offset(0.5, 0.1), const Offset(0.7, 0.7), const Offset(0.8, 0.4), const Offset(1, 0.9)], detailedDescription: 'One of the most reliable reversal patterns. Consists of three peaks: a higher peak (head) between two lower peaks (shoulders). The neckline connects the lows. A break below the neckline confirms the pattern.', tradingTips: ['Wait for neckline break before entering', 'Measure the distance from head to neckline for target', 'Volume typically decreases through the pattern'], commonMistakes: ['Entering before neckline confirmation', 'Ignoring volume analysis'], successProbability: 75),
      PatternModel(id: 'p2', title: 'Double Top', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.9), const Offset(0.3, 0.2), const Offset(0.5, 0.6), const Offset(0.7, 0.2), const Offset(1, 0.9)], detailedDescription: 'Two consecutive peaks at roughly the same level, indicating resistance. Price fails to break above this level twice, suggesting a reversal.', tradingTips: ['Confirm with support break', 'Target equals the distance from peaks to support'], commonMistakes: ['Assuming every two peaks form a double top'], successProbability: 70),
      PatternModel(id: 'p3', title: 'Double Bottom', description: 'Reversal', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.1), const Offset(0.3, 0.8), const Offset(0.5, 0.4), const Offset(0.7, 0.8), const Offset(1, 0.1)], successProbability: 70),
      PatternModel(id: 'p4', title: 'Cup & Handle', description: 'Continuation', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.1), const Offset(0.2, 0.7), const Offset(0.5, 0.8), const Offset(0.8, 0.7), const Offset(0.85, 0.6), const Offset(0.9, 0.65), const Offset(1, 0.4)], successProbability: 65),
      PatternModel(id: 'p5', title: 'Ascending Triangle', description: 'Continuation', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.8), const Offset(0.3, 0.2), const Offset(0.5, 0.6), const Offset(0.7, 0.2), const Offset(0.9, 0.4), const Offset(1, 0.2)], successProbability: 68),
      PatternModel(id: 'p6', title: 'Descending Triangle', description: 'Continuation', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.2), const Offset(0.3, 0.8), const Offset(0.5, 0.4), const Offset(0.7, 0.8), const Offset(0.9, 0.6), const Offset(1, 0.8)], successProbability: 66),
      PatternModel(id: 'p7', title: 'Bull Flag', description: 'Continuation', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.9), const Offset(0.2, 0.2), const Offset(0.3, 0.4), const Offset(0.4, 0.3), const Offset(0.5, 0.5), const Offset(0.6, 0.4), const Offset(1, 0.1)], successProbability: 63),
      PatternModel(id: 'p8', title: 'Bear Flag', description: 'Continuation', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.1), const Offset(0.2, 0.8), const Offset(0.3, 0.6), const Offset(0.4, 0.7), const Offset(0.5, 0.5), const Offset(0.6, 0.6), const Offset(1, 0.9)], successProbability: 62),
      PatternModel(id: 'p9', title: 'Sym. Triangle', description: 'Bilateral', direction: TrendDirection.neutral, chartPoints: [const Offset(0, 0.5), const Offset(0.2, 0.1), const Offset(0.4, 0.8), const Offset(0.6, 0.3), const Offset(0.8, 0.6), const Offset(1, 0.5)], successProbability: 55),
      PatternModel(id: 'p10', title: 'Falling Wedge', description: 'Reversal', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.1), const Offset(0.3, 0.7), const Offset(0.5, 0.5), const Offset(0.7, 0.8), const Offset(1, 0.3)], successProbability: 60),
      PatternModel(id: 'p11', title: 'Rising Wedge', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.9), const Offset(0.3, 0.3), const Offset(0.5, 0.5), const Offset(0.7, 0.2), const Offset(1, 0.7)], successProbability: 60),
      PatternModel(id: 'p12', title: 'Triple Top', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.8), const Offset(0.2, 0.2), const Offset(0.35, 0.6), const Offset(0.5, 0.2), const Offset(0.65, 0.6), const Offset(0.8, 0.2), const Offset(1, 0.8)], successProbability: 72),
      PatternModel(id: 'p13', title: 'Triple Bottom', description: 'Reversal', direction: TrendDirection.bullish, chartPoints: [const Offset(0, 0.2), const Offset(0.2, 0.8), const Offset(0.35, 0.4), const Offset(0.5, 0.8), const Offset(0.65, 0.4), const Offset(0.8, 0.8), const Offset(1, 0.2)], successProbability: 72),
      PatternModel(id: 'p14', title: 'Rectangle', description: 'Consolidation', direction: TrendDirection.neutral, chartPoints: [const Offset(0, 0.5), const Offset(0.2, 0.2), const Offset(0.4, 0.8), const Offset(0.6, 0.2), const Offset(0.8, 0.8), const Offset(1, 0.5)], successProbability: 55),
      PatternModel(id: 'p15', title: 'Diamond Top', description: 'Reversal', direction: TrendDirection.bearish, chartPoints: [const Offset(0, 0.5), const Offset(0.3, 0.1), const Offset(0.5, 0.5), const Offset(0.7, 0.9), const Offset(1, 0.5)], successProbability: 58),
    ];
  }
}

class ArticleRepository {
  List<ArticleCategory> getCategories() {
    return [
      ArticleCategory(name: 'Beginner Guides', subtitle: 'Start your trading journey', icon: Icons.school_rounded, articleCount: 3),
      ArticleCategory(name: 'Technical Analysis', subtitle: 'Charts, indicators & setups', icon: Icons.candlestick_chart_rounded, articleCount: 3),
      ArticleCategory(name: 'Risk Management', subtitle: 'Protect your capital', icon: Icons.shield_rounded, articleCount: 2),
      ArticleCategory(name: 'Trading Psychology', subtitle: 'Master your mindset', icon: Icons.psychology_rounded, articleCount: 2),
      ArticleCategory(name: 'Options Basics', subtitle: 'Calls, puts & strategies', icon: Icons.call_split_rounded, articleCount: 2),
      ArticleCategory(name: 'Swing Trading', subtitle: 'Multi-day setups', icon: Icons.swap_horiz_rounded, articleCount: 2),
      ArticleCategory(name: 'Intraday', subtitle: 'Day trading strategies', icon: Icons.speed_rounded, articleCount: 2),
      ArticleCategory(name: 'Investing', subtitle: 'Long-term wealth building', icon: Icons.savings_rounded, articleCount: 2),
      ArticleCategory(name: 'Moving Averages', subtitle: 'SMA, EMA & crossovers', icon: Icons.show_chart_rounded, articleCount: 2),
      ArticleCategory(name: 'RSI & MACD', subtitle: 'Momentum indicators', icon: Icons.trending_up_rounded, articleCount: 2),
      ArticleCategory(name: 'Support & Resistance', subtitle: 'Key price levels', icon: Icons.horizontal_rule_rounded, articleCount: 2),
      ArticleCategory(name: 'Volume Analysis', subtitle: 'Confirm with volume', icon: Icons.bar_chart_rounded, articleCount: 2),
      ArticleCategory(name: 'Fibonacci', subtitle: 'Retracements & extensions', icon: Icons.auto_graph_rounded, articleCount: 2),
      ArticleCategory(name: 'Common Mistakes', subtitle: 'What to avoid', icon: Icons.warning_amber_rounded, articleCount: 2),
      ArticleCategory(name: 'Market Terminology', subtitle: 'Key terms explained', icon: Icons.menu_book_rounded, articleCount: 2),
      ArticleCategory(name: 'Portfolio Building', subtitle: 'Diversify wisely', icon: Icons.pie_chart_rounded, articleCount: 2),
      ArticleCategory(name: 'Trading Strategies', subtitle: 'Proven approaches', icon: Icons.lightbulb_rounded, articleCount: 2),
      ArticleCategory(name: 'Market Indicators', subtitle: 'Breadth & sentiment', icon: Icons.dashboard_rounded, articleCount: 2),
      ArticleCategory(name: 'Chart Reading', subtitle: 'Timeframes & trends', icon: Icons.timeline_rounded, articleCount: 2),
      ArticleCategory(name: 'IPO Investing', subtitle: 'New listings guide', icon: Icons.rocket_launch_rounded, articleCount: 2),
    ];
  }

  List<ArticleModel> getArticlesForCategory(String category) {
    final allArticles = _getAllArticles();
    return allArticles.where((a) => a.category == category).toList();
  }

  List<ArticleModel> getFeaturedArticles() {
    return [
      _getAllArticles().firstWhere((a) => a.id == 'bg1'),
      _getAllArticles().firstWhere((a) => a.id == 'ta1'),
      _getAllArticles().firstWhere((a) => a.id == 'rm1'),
      _getAllArticles().firstWhere((a) => a.id == 'ps1'),
    ];
  }

  List<ArticleModel> _getAllArticles() {
    return [
      // Beginner Guides
      ArticleModel(id: 'bg1', title: 'What is the Stock Market?', subtitle: 'Understanding how markets work, who participates, and why prices move.', readingTimeMinutes: 5, difficulty: Difficulty.beginner, icon: Icons.school_rounded, category: 'Beginner Guides', sections: [
        ArticleSection(heading: 'Introduction', body: 'The stock market is a marketplace where buyers and sellers trade shares of publicly listed companies. It serves as a platform for companies to raise capital and for investors to build wealth over time.'),
        ArticleSection(heading: 'How Prices Move', body: 'Stock prices are driven by supply and demand. When more people want to buy a stock than sell it, the price goes up. When more people want to sell, the price goes down. News, earnings, economic data, and sentiment all influence this.'),
        ArticleSection(heading: 'Key Participants', body: 'Retail traders, institutional investors, mutual funds, hedge funds, and market makers all participate. Each has different strategies, time horizons, and impacts on price.'),
      ]),
      ArticleModel(id: 'bg2', title: 'Types of Orders', subtitle: 'Market, limit, stop-loss, and more.', readingTimeMinutes: 4, difficulty: Difficulty.beginner, icon: Icons.school_rounded, category: 'Beginner Guides', sections: [
        ArticleSection(heading: 'Market Orders', body: 'A market order buys or sells immediately at the best available price. It guarantees execution but not price.'),
        ArticleSection(heading: 'Limit Orders', body: 'A limit order sets the maximum price you\'re willing to pay (buy) or minimum you\'ll accept (sell). It guarantees price but not execution.'),
        ArticleSection(heading: 'Stop-Loss Orders', body: 'A stop-loss order automatically sells when a stock hits a specified price, protecting you from further losses.'),
      ]),
      ArticleModel(id: 'bg3', title: 'Reading a Stock Quote', subtitle: 'Understanding price, volume, and key metrics.', readingTimeMinutes: 3, difficulty: Difficulty.beginner, icon: Icons.school_rounded, category: 'Beginner Guides', sections: [
        ArticleSection(heading: 'Price Data', body: 'Open, High, Low, Close (OHLC) — these four prices define a stock\'s daily trading range. The close is the most important as it represents the final consensus price.'),
        ArticleSection(heading: 'Volume', body: 'Volume shows how many shares were traded. High volume suggests strong interest and conviction. Low volume may indicate indecision.'),
      ]),

      // Technical Analysis
      ArticleModel(id: 'ta1', title: 'Introduction to Technical Analysis', subtitle: 'Why charts matter and how to read them.', readingTimeMinutes: 6, difficulty: Difficulty.beginner, icon: Icons.candlestick_chart_rounded, category: 'Technical Analysis', sections: [
        ArticleSection(heading: 'What is Technical Analysis?', body: 'Technical analysis studies price action and volume data to forecast future price movements. It assumes that all known information is already reflected in the price.'),
        ArticleSection(heading: 'Price Action', body: 'Price action is the movement of a security\'s price over time. Traders study candlestick patterns, support/resistance levels, and trend lines to make decisions.'),
      ]),
      ArticleModel(id: 'ta2', title: 'Trend Lines & Channels', subtitle: 'Identifying and drawing trend lines.', readingTimeMinutes: 5, difficulty: Difficulty.intermediate, icon: Icons.candlestick_chart_rounded, category: 'Technical Analysis', sections: [
        ArticleSection(heading: 'Drawing Trend Lines', body: 'Connect two or more swing lows for an uptrend line, or two or more swing highs for a downtrend line. The more touches a trend line has, the more significant it is.'),
        ArticleSection(heading: 'Channels', body: 'A channel is formed by drawing parallel trend lines. Price tends to bounce between the upper and lower boundaries, creating trading opportunities.'),
      ]),
      ArticleModel(id: 'ta3', title: 'Candlestick Basics', subtitle: 'Understanding the language of candles.', readingTimeMinutes: 4, difficulty: Difficulty.beginner, icon: Icons.candlestick_chart_rounded, category: 'Technical Analysis', sections: [
        ArticleSection(heading: 'Reading Candles', body: 'Each candlestick shows open, high, low, and close. Green/white candles indicate closing higher than opening (bullish), while red/black indicate closing lower (bearish).'),
      ]),

      // Risk Management
      ArticleModel(id: 'rm1', title: 'Position Sizing', subtitle: 'How much to risk per trade.', readingTimeMinutes: 5, difficulty: Difficulty.intermediate, icon: Icons.shield_rounded, category: 'Risk Management', sections: [
        ArticleSection(heading: 'The 1-2% Rule', body: 'Never risk more than 1-2% of your total trading capital on a single trade. This ensures that even a string of losses won\'t wipe out your account.'),
        ArticleSection(heading: 'Calculating Position Size', body: 'Position Size = (Account Risk) / (Trade Risk per Share). If your account is ₹1,00,000 and you risk 1% (₹1,000), and your stop loss is ₹50 from entry, you can buy 20 shares.'),
      ]),
      ArticleModel(id: 'rm2', title: 'Stop Loss Strategies', subtitle: 'Protecting profits and limiting losses.', readingTimeMinutes: 4, difficulty: Difficulty.intermediate, icon: Icons.shield_rounded, category: 'Risk Management', sections: [
        ArticleSection(heading: 'Fixed Stop Loss', body: 'Set a stop loss at a specific price level or percentage below entry. Common approach: 2-3% below entry for swing trades.'),
        ArticleSection(heading: 'Trailing Stop', body: 'A trailing stop moves with the price in your favor, locking in profits. When price reverses by the trailing amount, the position is closed.'),
      ]),

      // Trading Psychology
      ArticleModel(id: 'ps1', title: 'Emotions in Trading', subtitle: 'Fear, greed, and how to manage them.', readingTimeMinutes: 5, difficulty: Difficulty.beginner, icon: Icons.psychology_rounded, category: 'Trading Psychology', sections: [
        ArticleSection(heading: 'Fear & Greed', body: 'Fear makes you exit too early or avoid good trades. Greed makes you hold too long or over-leverage. Both are natural but must be managed.'),
        ArticleSection(heading: 'Building Discipline', body: 'Follow your trading plan religiously. Write down your rules and review trades weekly. Consistency beats brilliance.'),
      ]),
      ArticleModel(id: 'ps2', title: 'Trading Journal', subtitle: 'Track, review, and improve.', readingTimeMinutes: 3, difficulty: Difficulty.beginner, icon: Icons.psychology_rounded, category: 'Trading Psychology', sections: [
        ArticleSection(heading: 'What to Log', body: 'Record: entry/exit prices, reasons for the trade, emotions during the trade, what went well, and what to improve.'),
      ]),

      // More categories with placeholder articles
      ..._generateCategoryArticles('Options Basics', Icons.call_split_rounded, [
        ('Understanding Calls & Puts', 'The building blocks of options trading.', 5, Difficulty.intermediate),
        ('Option Greeks Simplified', 'Delta, Gamma, Theta, and Vega explained.', 6, Difficulty.advanced),
      ]),
      ..._generateCategoryArticles('Swing Trading', Icons.swap_horiz_rounded, [
        ('Swing Trading Fundamentals', 'Multi-day momentum strategies.', 5, Difficulty.intermediate),
        ('Finding Swing Setups', 'Screens, patterns, and entry timing.', 4, Difficulty.intermediate),
      ]),
      ..._generateCategoryArticles('Intraday', Icons.speed_rounded, [
        ('Intraday Trading Basics', 'Day trading rules and requirements.', 5, Difficulty.intermediate),
        ('Scalping vs Momentum', 'Two popular intraday approaches.', 4, Difficulty.intermediate),
      ]),
      ..._generateCategoryArticles('Investing', Icons.savings_rounded, [
        ('Value vs Growth Investing', 'Two fundamental approaches to stock picking.', 5, Difficulty.beginner),
        ('SIP and Compounding', 'The power of systematic investment.', 4, Difficulty.beginner),
      ]),
      ..._generateCategoryArticles('Moving Averages', Icons.show_chart_rounded, [
        ('SMA vs EMA', 'Simple vs Exponential moving averages.', 4, Difficulty.intermediate),
        ('Golden & Death Cross', 'Major MA crossover signals.', 3, Difficulty.intermediate),
      ]),
      ..._generateCategoryArticles('RSI & MACD', Icons.trending_up_rounded, [
        ('RSI: Overbought & Oversold', 'Using Relative Strength Index effectively.', 5, Difficulty.intermediate),
        ('MACD Signal Line Crossovers', 'Momentum confirmation with MACD.', 4, Difficulty.intermediate),
      ]),
      ..._generateCategoryArticles('Support & Resistance', Icons.horizontal_rule_rounded, [
        ('Identifying Key Levels', 'How to find and draw S/R levels.', 5, Difficulty.beginner),
        ('Breakouts and Fakeouts', 'Trading when levels break or hold.', 4, Difficulty.intermediate),
      ]),
      ..._generateCategoryArticles('Volume Analysis', Icons.bar_chart_rounded, [
        ('Volume Price Analysis', 'Reading what volume tells you about price.', 5, Difficulty.intermediate),
        ('Volume Indicators', 'OBV, VWAP, and Volume Profile.', 5, Difficulty.advanced),
      ]),
      ..._generateCategoryArticles('Fibonacci', Icons.auto_graph_rounded, [
        ('Fibonacci Retracements', 'Key levels: 23.6%, 38.2%, 50%, 61.8%.', 5, Difficulty.intermediate),
        ('Fibonacci Extensions', 'Projecting price targets using extensions.', 4, Difficulty.advanced),
      ]),
      ..._generateCategoryArticles('Common Mistakes', Icons.warning_amber_rounded, [
        ('Top 10 Beginner Mistakes', 'Avoid these costly errors when starting out.', 5, Difficulty.beginner),
        ('Overtrading & Revenge Trading', 'Why less is often more in trading.', 4, Difficulty.beginner),
      ]),
      ..._generateCategoryArticles('Market Terminology', Icons.menu_book_rounded, [
        ('Essential Market Terms', 'Bull, bear, long, short, margin, and more.', 4, Difficulty.beginner),
        ('Order Types Glossary', 'GTT, IOC, AMO, bracket, cover orders.', 3, Difficulty.beginner),
      ]),
      ..._generateCategoryArticles('Portfolio Building', Icons.pie_chart_rounded, [
        ('Diversification Basics', 'Why and how to spread your risk.', 4, Difficulty.beginner),
        ('Asset Allocation', 'Balancing stocks, bonds, and alternatives.', 5, Difficulty.intermediate),
      ]),
      ..._generateCategoryArticles('Trading Strategies', Icons.lightbulb_rounded, [
        ('Breakout Trading', 'Entering when price breaks key levels.', 5, Difficulty.intermediate),
        ('Mean Reversion', 'Trading when prices deviate from averages.', 5, Difficulty.advanced),
      ]),
      ..._generateCategoryArticles('Market Indicators', Icons.dashboard_rounded, [
        ('Market Breadth', 'Advance-decline ratio and market health.', 4, Difficulty.intermediate),
        ('VIX: Fear Index', 'Understanding market volatility.', 4, Difficulty.intermediate),
      ]),
      ..._generateCategoryArticles('Chart Reading', Icons.timeline_rounded, [
        ('Timeframe Selection', 'Daily, weekly, hourly — which to use.', 4, Difficulty.beginner),
        ('Multiple Timeframe Analysis', 'Confirming setups across timeframes.', 5, Difficulty.intermediate),
      ]),
      ..._generateCategoryArticles('IPO Investing', Icons.rocket_launch_rounded, [
        ('How IPOs Work', 'From pricing to listing day.', 5, Difficulty.beginner),
        ('Evaluating IPOs', 'GMP, valuations, and red flags.', 5, Difficulty.intermediate),
      ]),
    ];
  }

  List<ArticleModel> _generateCategoryArticles(
    String category,
    IconData icon,
    List<(String title, String subtitle, int time, Difficulty diff)> items,
  ) {
    return items.asMap().entries.map((e) {
      final idx = e.key;
      final item = e.value;
      return ArticleModel(
        id: '${category.toLowerCase().replaceAll(' ', '_')}_$idx',
        title: item.$1,
        subtitle: item.$2,
        readingTimeMinutes: item.$3,
        difficulty: item.$4,
        icon: icon,
        category: category,
        sections: [
          ArticleSection(
            heading: 'Overview',
            body: 'This article covers ${item.$1.toLowerCase()}. ${item.$2}',
          ),
        ],
      );
    }).toList();
  }
}

// ==========================================
// 3. LOGIC LAYER (Providers)
// ==========================================

final patternRepositoryProvider = Provider((ref) => PatternRepository());
final articleRepositoryProvider = Provider((ref) => ArticleRepository());

final candlestickPatternsProvider = Provider<List<PatternModel>>((ref) {
  return ref.watch(patternRepositoryProvider).getCandlestickPatterns();
});

final chartPatternsProvider = Provider<List<PatternModel>>((ref) {
  return ref.watch(patternRepositoryProvider).getChartPatterns();
});

final categoriesProvider = Provider<List<ArticleCategory>>((ref) {
  return ref.watch(articleRepositoryProvider).getCategories();
});

final featuredArticlesProvider = Provider<List<ArticleModel>>((ref) {
  return ref.watch(articleRepositoryProvider).getFeaturedArticles();
});

// The index provider for the tabs
final yourActivitiesIndexProvider = StateProvider<int>((ref) => 0);
