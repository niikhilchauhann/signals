import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/home_screen_providers.dart';
import '/core/export.dart';
import 'package:flutter/material.dart';

class MarketOverviewCard extends ConsumerWidget {
  const MarketOverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketOverviewProvider);

    return market.when(
      loading: () => Center(child: const CircularProgressIndicator()).py(32),
      error: (ob, st) {
        debugPrint("Error - $ob - $st");
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: AppDecorations.card(),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.grey, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Unable to load market data',
                    style: AppTextTheme.size14Normal.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      data: (data) {
        if (data.bias == 'Market Closed') {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: AppDecorations.card(),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.access_time_rounded,
                        color: AppColors.grey, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Market Closed', style: AppTextTheme.size16Bold),
                        const SizedBox(height: 2),
                        Text(
                          'Come back during market hours',
                          style: AppTextTheme.size12Normal.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final biasColor = _biasColor(data.bias);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: AppDecorations.card(radius: AppRadius.cardLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: bias chip + "Today" label
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: AppDecorations.chip(color: biasColor),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: biasColor, size: 8),
                          const SizedBox(width: 6),
                          Text(
                            data.bias,
                            style: AppTextTheme.size12Bold.copyWith(
                              color: biasColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Today',
                      style: AppTextTheme.size12Normal.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Title
                Text('Market Overview', style: AppTextTheme.size18Bold),
                const SizedBox(height: 4),
                Text(
                  'Key intraday levels to guide your entries and exits.',
                  style: AppTextTheme.size14Normal.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 16),

                // Metrics in 2x2 grid
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Intraday High',
                        value: data.intradayHigh.toStringAsFixed(0),
                        icon: Icons.arrow_upward_rounded,
                        color: AppColors.green,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.innerGap),
                    Expanded(
                      child: _MetricCard(
                        label: 'Intraday Low',
                        value: data.intradayLow.toStringAsFixed(0),
                        icon: Icons.arrow_downward_rounded,
                        color: AppColors.redLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.innerGap),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: 'Buy Above',
                        value: data.buyAbove.toStringAsFixed(0),
                        icon: Icons.trending_up_rounded,
                        color: AppColors.green,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.innerGap),
                    Expanded(
                      child: _MetricCard(
                        label: 'Sell Below',
                        value: data.sellBelow.toStringAsFixed(0),
                        icon: Icons.trending_down_rounded,
                        color: AppColors.redLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Note
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: AppDecorations.infoContainer(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notes_rounded,
                          color: AppColors.grey, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data.note,
                          style: AppTextTheme.size12Normal.copyWith(
                            color: AppColors.darkGrey,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Color _biasColor(String bias) {
  switch (bias.toLowerCase()) {
    case 'bullish':
      return AppColors.green;
    case 'bearish':
      return AppColors.redLight;
    default:
      return AppColors.secondaryViolet;
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextTheme.size10Normal.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: AppTextTheme.size14Bold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
