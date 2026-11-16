import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/trade_setup_model.dart';
import '../../providers/home_screen_providers.dart';
import '../all_trades_screen.dart';
import '/core/export.dart';
import 'package:flutter/material.dart';

class TopTradesSection extends ConsumerWidget {
  const TopTradesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradesAsync = ref.watch(topTradesProvider);

    return tradesAsync.when(
      loading: () => Center(child: const CircularProgressIndicator()).py(32),

      error: (ob, st) {
        debugPrint("Top Trade Fetch Error - $ob\n$st");
        return const SizedBox.shrink();
      },

      data: (data) {
        final trades = data.isEmpty
            ? [
                TradeSetup(
                  name: 'NSE',
                  symbol: 'NIFTY 50',
                  score: 50,
                  horizon: 'Intraday',
                  signals: 'Market sideways / no clear edge',
                  verdict: TradeVerdict.watch,
                ),
              ]
            : data;

        // Sort by score descending and take top 3
        final sorted = List<TradeSetup>.from(trades)
          ..sort((a, b) => b.score.compareTo(a.score));
        final displayList = sorted.sublist(0, min(3, sorted.length));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Top Trade Setups", style: AppTextTheme.size20Bold),
                  const SizedBox(height: 2),
                  Text(
                    "Highest-confidence signals for today",
                    style: AppTextTheme.size14Normal.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),

            // Trade cards — vertical list
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                children: displayList
                    .map((trade) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.itemGap,
                          ),
                          child: TradeCard(trade: trade),
                        ))
                    .toList(),
              ),
            ),

            // See All button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: _SeeAllButton(
                label: 'See All Trade Setups',
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AllTradesScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
        );
      },
    );
  }
}

class TradeCard extends StatelessWidget {
  final TradeSetup trade;

  const TradeCard({super.key, required this.trade});

  Color _verdictColor(TradeVerdict v) {
    switch (v) {
      case TradeVerdict.buy:
        return AppColors.green;
      case TradeVerdict.watch:
        return AppColors.yellow;
      case TradeVerdict.avoid:
        return AppColors.redLight;
    }
  }

  IconData _verdictIcon(TradeVerdict v) {
    switch (v) {
      case TradeVerdict.buy:
        return Icons.trending_up_rounded;
      case TradeVerdict.watch:
        return Icons.remove_red_eye_outlined;
      case TradeVerdict.avoid:
        return Icons.block_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _verdictColor(trade.verdict);
    final double progress = (trade.score.clamp(0, 100) / 100).toDouble();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: name + verdict chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trade.name, style: AppTextTheme.size18Bold),
                    const SizedBox(height: 4),
                    Text(
                      trade.symbol,
                      style: AppTextTheme.size14Normal.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: AppDecorations.chip(color: color),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_verdictIcon(trade.verdict), size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(
                      trade.verdict.name.toUpperCase(),
                      style: AppTextTheme.size12Bold.copyWith(color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),

          // Tags row: horizon + confidence
          Row(
            children: [
              _Tag(label: trade.horizon, icon: Icons.schedule_rounded),
              const SizedBox(width: AppSpacing.innerGap),
              _Tag(
                label: 'Confidence ${trade.score}%',
                icon: Icons.bolt_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),

          // Confidence bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.chipBackground,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),

          // Signals text
          Text(
            trade.signals,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.size14Normal.copyWith(
              color: AppColors.darkGrey,
            ),
          ),

          // Entry / Target / Stop Loss row
          if (trade.entry != null ||
              trade.target != null ||
              trade.stopLoss != null) ...[
            const SizedBox(height: AppSpacing.itemGap),
            Row(
              children: [
                if (trade.entry != null)
                  Expanded(
                    child: _LevelPill(
                      label: 'Entry',
                      value: '₹${trade.entry!.toStringAsFixed(0)}',
                      color: AppColors.primaryPurple,
                    ),
                  ),
                if (trade.target != null) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: _LevelPill(
                      label: 'Target',
                      value: '₹${trade.target!.toStringAsFixed(0)}',
                      color: AppColors.green,
                    ),
                  ),
                ],
                if (trade.stopLoss != null) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: _LevelPill(
                      label: 'SL',
                      value: '₹${trade.stopLoss!.toStringAsFixed(0)}',
                      color: AppColors.redLight,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Tag({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: AppDecorations.metricPill(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.grey),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextTheme.size12Normal.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _LevelPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextTheme.size10Normal.copyWith(
              color: color.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextTheme.size12Bold.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _SeeAllButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SeeAllButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextTheme.size14Bold.copyWith(
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: AppColors.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }
}
