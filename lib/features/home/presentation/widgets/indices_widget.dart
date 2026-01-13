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

        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: data.bias == 'Bearish'
                ? AppColors.redLight
                : data.bias == 'Bullish'
                ? AppColors.green
                : AppColors.secondaryViolet,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Market Overview — ${data.bias}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarketDataLabel(
                        label: "Intraday High: ",
                        value: data.intradayHigh.toStringAsFixed(0),
                      ),
                      MarketDataLabel(
                        label: "Intraday Low: ",
                        value: data.intradayLow.toStringAsFixed(0),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarketDataLabel(
                        label: "Buy Above: ",
                        value: data.buyAbove.toStringAsFixed(0),
                      ),
                      MarketDataLabel(
                        label: "Sell Below: ",
                        value: data.sellBelow.toStringAsFixed(0),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 8),

              Text(
                "Note: ${data.note}",
                style: AppTextTheme.size14Bold.copyWith(
                  color: AppColors.white,
                  // fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MarketDataLabel extends StatelessWidget {
  final String label;
  final String value;

  const MarketDataLabel({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label (fixed)
          Text(
            label,
            style: AppTextTheme.size14Normal.copyWith(color: AppColors.white),
          ),

          // const SizedBox(width: 8),

          // Value (flexible)
          Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.size14Bold.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
