import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/export.dart';
import 'discover_repository.dart';

class PatternCard extends StatelessWidget {
  final PatternModel pattern;
  final Widget visual;

  const PatternCard({super.key, required this.pattern, required this.visual});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText;

    switch (pattern.direction) {
      case TrendDirection.bullish:
        badgeColor = AppColors.green;
        badgeText = 'BULL';
        break;
      case TrendDirection.bearish:
        badgeColor = AppColors.red;
        badgeText = 'BEAR';
        break;
      case TrendDirection.neutral:
        badgeColor = AppColors.primaryPurple;
        badgeText = 'NEUT';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Visual Area
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: visual,
                ),
              ),
            ),
          ),
          // Info Area
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pattern.title,
                        style: AppTextTheme.size14Bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.heightBox,
                      Text(
                        pattern.description,
                        style: AppTextTheme.size12Normal,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Visual: Single Candlestick Built with Containers ----
class SingleCandleWidget extends StatelessWidget {
  final double open;
  final double close;
  final double high;
  final double low;

  const SingleCandleWidget({
    super.key,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    final isGreen = close >= open;
    final color = isGreen ? AppColors.green : AppColors.red;

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        // Invert Y axis conceptually (0 is bottom in chart logic, but top in UI)
        // So Top = (1 - high), Bottom = (1 - low)

        final wickTop = (1 - high) * h;
        final wickHeight = (high - low) * h;

        final bodyTop = (1 - (isGreen ? close : open)) * h;
        final bodyHeight = ((close - open).abs()) * h;

        return SizedBox(
          width: 12,
          height: h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Wick
              Positioned(
                top: wickTop,
                height: wickHeight == 0 ? 1 : wickHeight,
                child: Container(width: 2, color: color),
              ),
              // Body
              Positioned(
                top: bodyTop,
                height: bodyHeight == 0 ? 2 : bodyHeight,
                child: Container(
                  width: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---- Visual: Chart Line Built with CustomPaint (Wrapped in Container) ----
class ChartPatternVisual extends StatelessWidget {
  final List<Offset> points;
  final Color color;

  const ChartPatternVisual({
    super.key,
    required this.points,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        size: Size.infinite,
        painter: ChartLinePainter(points: points, color: color),
      ),
    );
  }
}

class ChartLinePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  ChartLinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Scale points to size
    final start = points[0];
    path.moveTo(start.dx * size.width, (1 - start.dy) * size.height);

    for (int i = 1; i < points.length; i++) {
      final p = points[i];
      path.lineTo(p.dx * size.width, (1 - p.dy) * size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartPatterns = ref.watch(chartPatternsProvider);
    final candlePatterns = ref.watch(candlestickPatternsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediaQuery.of(context).padding.top.heightBox,
          20.heightBox,
          Text('Market Education', style: AppTextTheme.size20Bold).px(16),
          24.heightBox,
          Expanded(
            child: CustomTabSwitcher(
              indexProvider: yourActivitiesIndexProvider,
              tabs: ['Patterns', 'Candlesticks'],
              tabWidgets: [
                // 1. Chart Patterns Grid
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: chartPatterns.length,
                  itemBuilder: (context, index) {
                    final p = chartPatterns[index];
                    return PatternCard(
                      pattern: p,
                      visual: ChartPatternVisual(
                        points: p.chartPoints!,
                        color: p.direction == TrendDirection.bullish
                            ? AppColors.green
                            : (p.direction == TrendDirection.bearish
                                  ? AppColors.red
                                  : AppColors.black),
                      ),
                    );
                  },
                ),

                // 2. Candlestick Patterns Grid
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: candlePatterns.length,
                  itemBuilder: (context, index) {
                    final p = candlePatterns[index];
                    return PatternCard(
                      pattern: p,
                      visual: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: p.candleData!.map((d) {
                          return SingleCandleWidget(
                            open: d[0],
                            close: d[1],
                            low: d[2],
                            high: d[3],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
