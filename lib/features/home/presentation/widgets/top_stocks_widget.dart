import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/trade_setup_model.dart';
import '../../providers/home_screen_providers.dart';
import '/config/theme/app_text_theme.dart';
import '/config/theme/app_colors.dart';

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
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                itemCount: trades.length,
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
    final color = verdictColor(verdict);
    final double progress = (score.clamp(0, 100) / 100).toDouble();

    return Container(
      height: 240,
      width: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF2F6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F5)),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock, style: AppTextTheme.size18Bold),
                    const SizedBox(height: 4),
                    Text(
                      stockSymbol,
                      style: AppTextTheme.size14Bold.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              _VerdictChip(verdict: verdict, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _Tag(label: horizon, icon: Icons.schedule_rounded),
              const SizedBox(width: 8),
              _Tag(label: 'Score $score', icon: Icons.bolt_rounded),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE4E7F2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
          const SizedBox(height: 12),
          Text(
            signals,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextTheme.size14Normal,
          ),
          const Spacer(),
          Text(
            "Verdict: ${verdict.name.toUpperCase()}",
            style: AppTextTheme.accent16Bold.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _VerdictChip extends StatelessWidget {
  final TradeVerdict verdict;
  final Color color;

  const _VerdictChip({required this.verdict, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            verdict.name.toUpperCase(),
            style: AppTextTheme.size12Bold.copyWith(color: color),
          ),
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
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2FB),
        borderRadius: BorderRadius.circular(10),
      ),
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
