import 'dart:math';

import '/features/algorithm_engine/data/models/ipo_model.dart';
import '/features/home/presentation/ipo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../algorithm_engine/data/providers/other_assets_provider.dart';
import '/core/export.dart';
import 'package:flutter/material.dart';

class TopIPOsSection extends ConsumerWidget {
  const TopIPOsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipos = ref.watch(enrichedActiveIposProvider);

    return ipos.when(
      loading: () => Center(child: const CircularProgressIndicator()).py(32),
      error: (ob, st) {
        debugPrint("IPO Fetch Error - $ob - $st");
        return const SizedBox.shrink();
      },
      data: (data) {
        if (data.isEmpty) return const SizedBox.shrink();

        final displayList = data.sublist(0, min(3, data.length));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Top IPOs", style: AppTextTheme.size20Bold),
                        const SizedBox(height: 2),
                        Text(
                          "Fresh listings with live GMP and sentiment",
                          style: AppTextTheme.size14Normal.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 235,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.cardPadding,
                ),
                itemCount: displayList.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.itemGap),
                itemBuilder: (context, index) {
                  final ipo = displayList[index];
                  return IpoCard(ipo: ipo);
                },
              ),
            ),
            // See All IPOs button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: _SeeAllButton(
                label: 'See All IPOs',
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const IpoScreen(),
                    ),
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

class IpoCard extends StatelessWidget {
  final IPOModel ipo;

  const IpoCard({super.key, required this.ipo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  ipo.name,
                  maxLines: 2,
                  style: AppTextTheme.size18Bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: AppDecorations.chip(
                  color: ipo.isSme
                      ? AppColors.hotPink
                      : AppColors.primaryPurple,
                ),
                child: Text(
                  ipo.isSme ? 'SME' : 'Mainboard',
                  style: AppTextTheme.size12Bold.copyWith(
                    color: ipo.isSme
                        ? AppColors.hotPink
                        : AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.itemGap),
          _IPORow(
            label: "End Date",
            value: ipo.biddingEndDate.toString().split(' ').first,
          ),
          _IPORow(label: "GMP", value: ipo.gmp ?? '—'),
          _IPORow(label: "Confidence", value: "${ipo.confidence}"),
          _IPORow(label: "Sentiment", value: ipo.sentiment ?? 'Neutral'),
        ],
      ),
    );
  }
}

class _IPORow extends StatelessWidget {
  final String label;
  final String value;

  const _IPORow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextTheme.size12Normal.copyWith(color: AppColors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.size14Bold,
            ),
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
