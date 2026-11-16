import '/core/export.dart';
import 'package:flutter/material.dart';

import 'widgets/indices_widget.dart';
import 'widgets/ipos_widget.dart';
import 'widgets/top_stocks_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppDecorations.screenBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const _HomeHeader(),
                const SizedBox(height: AppSpacing.sectionGap),
                const _SectionHeader(
                  title: 'Market Pulse',
                  subtitle: 'Bias, triggers, and key levels for today',
                ).px(AppSpacing.screenPadding),
                const SizedBox(height: AppSpacing.itemGap),
                const MarketOverviewCard(),
                const SizedBox(height: AppSpacing.sectionGap),
                const TopIPOsSection(),
                const SizedBox(height: AppSpacing.innerGap),
                const TopTradesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _formattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: AppTextTheme.size14Normal.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text('Signals', style: AppTextTheme.size24Bold),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.chip),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(width: 6),
                Text(
                  _formattedDate(),
                  style: AppTextTheme.size12Bold.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextTheme.size20Bold),
        const SizedBox(height: AppSpacing.tinyGap),
        Text(
          subtitle,
          style: AppTextTheme.size14Normal.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}
