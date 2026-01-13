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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F9FF), Color(0xFFEFF2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaQuery.of(context).padding.top.heightBox,
                12.heightBox,
                const _HeroHeader(),
                18.heightBox,
                const _SectionHeader(
                  title: 'Market Pulse',
                  subtitle: 'Bias, triggers, and notes for today',
                ).px(16),
                12.heightBox,
                const MarketOverviewCard(),
                16.heightBox,
                const TopIPOsSection(),
                8.heightBox,
                const TopTradesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2742F5), Color(0xFF5B7BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.auto_graph_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text('Signals Pulse', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Daily analysis tailored for decisive trades.',
              style: AppTextTheme.size24Bold.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Stay ahead with real-time market pulse, curated IPOs, and high-conviction setups.',
              style: AppTextTheme.size14Normal.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _HeroChip(label: 'Updated every session'),
                _HeroChip(label: 'Human + Quant insights'),
                _HeroChip(label: 'Actionable in minutes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;

  const _HeroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: AppTextTheme.size12Normal.copyWith(color: Colors.white),
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
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextTheme.size14Normal.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}
