import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/home_screen_providers.dart';
import '/core/export.dart';
import 'package:flutter/material.dart';

// class IndexButtons extends StatelessWidget {
//   const IndexButtons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final indexes = ['NIFTY 50', 'BANKNIFTY', 'FINNIFTY', 'MIDCAP'];

//     return SizedBox(
//       height: 42,
//       child: ListView.separated(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         scrollDirection: Axis.horizontal,
//         itemCount: indexes.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           return OutlinedButton(
//             onPressed: () {},
//             style: OutlinedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(indexes[index], style: AppTextTheme.accent14Bold),
//           );
//         },
//       ),
//     );
//   }
// }

class MarketOverviewCard extends ConsumerWidget {
  const MarketOverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketOverviewProvider);

    return market.when(
      loading: () => Center(child: const CircularProgressIndicator()).py(32),
      error: (ob, st) {
        debugPrint("Error - $ob - $st");
        return Text("Error - $ob - $st");
      },
      data: (data) {
        if (data.bias == 'Market Closed') {
          return Center(
            child: Text(
              'Market is closed today.\nCome back during market hours.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ).py(24);
        }

        final biasColor = _biasColor(data.bias);

        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                biasColor.withOpacity(0.95),
                biasColor.withOpacity(0.85),
                biasColor.withOpacity(0.70),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 18,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Colors.white, size: 10),
                        const SizedBox(width: 8),
                        Text(
                          data.bias,
                          style: AppTextTheme.size14Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Today',
                    style: AppTextTheme.size14Normal.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Market Overview',
                style: AppTextTheme.size18Bold.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Key intraday levels to guide your entries and exits.',
                style: AppTextTheme.size14Normal.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricPill(
                    label: 'Intraday High',
                    value: data.intradayHigh.toStringAsFixed(0),
                  ),
                  _MetricPill(
                    label: 'Intraday Low',
                    value: data.intradayLow.toStringAsFixed(0),
                  ),
                  _MetricPill(
                    label: 'Buy Above',
                    value: data.buyAbove.toStringAsFixed(0),
                  ),
                  _MetricPill(
                    label: 'Sell Below',
                    value: data.sellBelow.toStringAsFixed(0),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _NoteCard(note: data.note),
            ],
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

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetricPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextTheme.size12Normal.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextTheme.size16Bold.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notes_rounded, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              note,
              style: AppTextTheme.size14Normal.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
