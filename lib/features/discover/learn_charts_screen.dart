import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/export.dart';
import 'discover_repository.dart';

class LearnChartsScreen extends ConsumerWidget {
  const LearnChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartPatterns = ref.watch(chartPatternsProvider);
    final candlePatterns = ref.watch(candlestickPatternsProvider);

    return Scaffold(
      body: Container(
        decoration: AppDecorations.screenBackground,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    8,
                    AppSpacing.screenPadding,
                    AppSpacing.sectionGap,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child:
                              const Icon(Icons.arrow_back_rounded, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Learn Charts', style: AppTextTheme.size24Bold),
                          const SizedBox(height: 2),
                          Text(
                            'Visual pattern guide',
                            style: AppTextTheme.size12Normal.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Chart Patterns section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    AppSpacing.itemGap,
                  ),
                  child: Text('Chart Patterns', style: AppTextTheme.size18Bold),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.itemGap,
                        ),
                        child: _PatternExpandableCard(
                          pattern: chartPatterns[index],
                          visual: _ChartPatternVisual(
                            points: chartPatterns[index].chartPoints!,
                            color: _directionColor(
                              chartPatterns[index].direction,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: chartPatterns.length,
                  ),
                ),
              ),

              // Candlestick Patterns section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.sectionGap,
                    AppSpacing.screenPadding,
                    AppSpacing.itemGap,
                  ),
                  child: Text(
                    'Candlestick Patterns',
                    style: AppTextTheme.size18Bold,
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  24,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.itemGap,
                        ),
                        child: _PatternExpandableCard(
                          pattern: candlePatterns[index],
                          visual: _CandlestickVisual(
                            candleData: candlePatterns[index].candleData!,
                            direction: candlePatterns[index].direction,
                          ),
                        ),
                      );
                    },
                    childCount: candlePatterns.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _directionColor(TrendDirection direction) {
  switch (direction) {
    case TrendDirection.bullish:
      return AppColors.green;
    case TrendDirection.bearish:
      return AppColors.redLight;
    case TrendDirection.neutral:
      return AppColors.secondaryViolet;
  }
}

// ─────────────────────────────────────────
// Expandable Pattern Card
// ─────────────────────────────────────────

class _PatternExpandableCard extends StatefulWidget {
  final PatternModel pattern;
  final Widget visual;

  const _PatternExpandableCard({
    required this.pattern,
    required this.visual,
  });

  @override
  State<_PatternExpandableCard> createState() =>
      _PatternExpandableCardState();
}

class _PatternExpandableCardState extends State<_PatternExpandableCard> {
  final ValueNotifier<bool> _expanded = ValueNotifier(false);

  @override
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pattern;
    final dirColor = _directionColor(p.direction);

    return ValueListenableBuilder<bool>(
      valueListenable: _expanded,
      builder: (context, expanded, child) {
        return Container(
          decoration: AppDecorations.card(),
          child: Column(
            children: [
              // Header — always visible
              InkWell(
                onTap: () => _expanded.value = !expanded,
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Row(
                    children: [
                      // Visual preview
                      Container(
                        width: 56,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: widget.visual,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: AppTextTheme.size16Bold),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _DirectionBadge(direction: p.direction),
                                if (p.successProbability != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.chipBackground,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${p.successProbability}% success',
                                      style: AppTextTheme.size10Normal.copyWith(
                                        color: AppColors.darkGrey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

          // Expanded content
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding,
                0,
                AppSpacing.cardPadding,
                AppSpacing.cardPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large visual
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: widget.visual,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Description
                  Text(p.description, style: AppTextTheme.size14Normal),

                  if (p.detailedDescription != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      p.detailedDescription!,
                      style: AppTextTheme.size14Normal.copyWith(
                        color: AppColors.darkGrey,
                        height: 1.5,
                      ),
                    ),
                  ],

                  // Trading Tips
                  if (p.tradingTips != null && p.tradingTips!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _SectionTitle(
                      icon: Icons.lightbulb_outline,
                      label: 'Trading Tips',
                      color: AppColors.green,
                    ),
                    const SizedBox(height: 8),
                    ...p.tradingTips!.map(
                      (tip) => _BulletItem(text: tip, color: AppColors.green),
                    ),
                  ],

                  // Common Mistakes
                  if (p.commonMistakes != null &&
                      p.commonMistakes!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _SectionTitle(
                      icon: Icons.warning_amber_rounded,
                      label: 'Common Mistakes',
                      color: AppColors.redLight,
                    ),
                    const SizedBox(height: 8),
                    ...p.commonMistakes!.map(
                      (m) => _BulletItem(text: m, color: AppColors.redLight),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
      },
    );
  }
}

class _DirectionBadge extends StatelessWidget {
  final TrendDirection direction;

  const _DirectionBadge({required this.direction});

  @override
  Widget build(BuildContext context) {
    final color = _directionColor(direction);
    String label;
    switch (direction) {
      case TrendDirection.bullish:
        label = 'BULLISH';
        break;
      case TrendDirection.bearish:
        label = 'BEARISH';
        break;
      case TrendDirection.neutral:
        label = 'NEUTRAL';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextTheme.size10Normal.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionTitle({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextTheme.size14Bold.copyWith(color: color),
        ),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;

  const _BulletItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 5, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextTheme.size12Normal.copyWith(
                color: AppColors.darkGrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Chart Pattern Visual
// ─────────────────────────────────────────

class _ChartPatternVisual extends StatelessWidget {
  final List<Offset> points;
  final Color color;

  const _ChartPatternVisual({required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ChartLinePainter(points: points, color: color),
    );
  }
}

class _ChartLinePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  _ChartLinePainter({required this.points, required this.color});

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

// ─────────────────────────────────────────
// Candlestick Visual
// ─────────────────────────────────────────

class _CandlestickVisual extends StatelessWidget {
  final List<List<double>> candleData;
  final TrendDirection direction;

  const _CandlestickVisual({
    required this.candleData,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: candleData.map((d) {
            final open = d[0];
            final close = d[1];
            final low = d[2];
            final high = d[3];
            final isGreen = close >= open;
            final color = isGreen ? AppColors.green : AppColors.redLight;

            final h = constraints.maxHeight;
            final wickTop = (1 - high) * h;
            final wickHeight = (high - low) * h;
            final bodyTop = (1 - (isGreen ? close : open)) * h;
            final bodyHeight = ((close - open).abs()) * h;

            return SizedBox(
              width: 10,
              height: h,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: wickTop,
                    height: wickHeight == 0 ? 1 : wickHeight,
                    child: Container(width: 2, color: color),
                  ),
                  Positioned(
                    top: bodyTop,
                    height: bodyHeight == 0 ? 2 : bodyHeight,
                    child: Container(
                      width: 8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
