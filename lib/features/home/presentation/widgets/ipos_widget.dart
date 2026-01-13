import 'package:cupcake/core/global_widgets/custom_text_button.dart';
import 'package:cupcake/features/algorithm_engine/data/models/ipo_model.dart';
import 'package:cupcake/features/home/presentation/ipo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../algorithm_engine/data/providers/other_assets_provider.dart';
import '../../providers/home_screen_providers.dart';
import '/config/theme/app_text_theme.dart';
import '/config/theme/app_colors.dart';

import '/core/extensions/app_extensions.dart';
import 'package:flutter/material.dart';

class TopIPOsSection extends ConsumerWidget {
  const TopIPOsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refresh = ref.read(ipoRefreshProvider);
    final ipos = ref.watch(enrichedActiveIposProvider);

    return ipos.when(
      loading: () => Center(child: const CircularProgressIndicator()).py(32),
      error: (ob, st) {
        debugPrint("IPO Fetch Error - $ob - $st");
        return Text("Error - $ob - $st");
      },
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Top IPOs", style: AppTextTheme.size20Bold),
                        SizedBox(height: 2),
                        Text(
                          "Fresh listings with live GMP and sentiment",
                          style: AppTextTheme.size14Normal,
                        ),
                      ],
                    ),
                  ),
                  CustomTextButton(
                    ontap: () async {
                      refresh();
                    },
                    title: 'Refresh',
                  ),
                  12.widthBox,
                  CustomTextButton(
                    ontap: () async {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const IpoScreen(),
                        ),
                      );
                    },
                    title: 'See All',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 235,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final ipo = data[index];
                  return IpoCard(ipo: ipo);
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF3F6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E9F5)),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
      ),
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
                decoration: BoxDecoration(
                  color:
                      (ipo.isSme ? AppColors.hotPink : AppColors.primaryPurple)
                          .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ipo.isSme ? 'SME' : 'Mainboard',
                  style: AppTextTheme.accent12Bold.copyWith(
                    color: ipo.isSme
                        ? AppColors.hotPink
                        : AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IPORow(
            label: "End Date",
            value: ipo.biddingEndDate.toString().split(' ').first,
          ),
          IPORow(label: "GMP", value: ipo.gmp ?? '—'),
          IPORow(label: "Confidence", value: "${ipo.confidence}"),
          IPORow(label: "Sentiment", value: ipo.sentiment ?? 'Neutral'),
        ],
      ),
    );
  }
}

class IPORow extends StatelessWidget {
  final String label;
  final String value;

  const IPORow({super.key, required this.label, required this.value});

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
