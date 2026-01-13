import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/trade_setup_model.dart';
import '../../providers/home_screen_providers.dart';
import '/config/theme/app_text_theme.dart';

import '/core/extensions/app_extensions.dart';
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
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Failed to load trade setups"),
        );
      },

      data: (data) {
        // 🔥 HARD GUARANTEE: never empty UI
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Top Trade Setups", style: AppTextTheme.size20Bold).px(16),

            SizedBox(
              height: 240,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                itemCount: trades.length, // ✅ FIXED
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final trade = trades[index];
                  return TradeCard(
                    stock: trade.name,
                    stockSymbol: trade.symbol,
                    score: trade.score,
                    horizon: trade.horizon,
                    verdict: trade.verdict,
                    signals: trade.signals,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class TradeCard extends StatelessWidget {
  final String stock;
  final String stockSymbol;
  final int score;
  final String horizon;
  final TradeVerdict verdict;
  final String signals;

  const TradeCard({
    super.key,
    required this.stock,
    required this.stockSymbol,
    required this.score,
    required this.horizon,
    required this.verdict,
    required this.signals,
  });

  Color verdictColor(TradeVerdict v) {
    switch (v) {
      case TradeVerdict.buy:
        return Colors.green;
      case TradeVerdict.watch:
        return Colors.orange;
      case TradeVerdict.avoid:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      stockSymbol,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Score: $score",
                  style: TextStyle(
                    color: verdictColor(verdict),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text("Horizon: $horizon", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text("Signals: $signals", maxLines: 3),
          const SizedBox(height: 6),
          Text(
            "Verdict: ${verdict.name.toUpperCase()}",
            style: AppTextTheme.accent16Bold,
          ),
        ],
      ),
    );
  }
}
