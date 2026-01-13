import 'package:cupcake/core/global_widgets/custom_text_button.dart';
import 'package:cupcake/features/algorithm_engine/data/models/ipo_model.dart';
import 'package:cupcake/features/home/presentation/ipo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../algorithm_engine/data/providers/other_assets_provider.dart';
import '../../providers/home_screen_providers.dart';
import '/config/theme/app_text_theme.dart';

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
            Row(
              children: [
                Expanded(
                  child: const Text(
                    "Top IPOs",
                    style: AppTextTheme.size20Bold,
                  ).px(16),
                ),

                CustomTextButton(
                  ontap: () async {
                    refresh();
                    // await ref.read(ipoWithGmpProvider.future);
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
                16.widthBox,
              ],
            ),
            SizedBox(
              height: 245,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ipo.name,
            maxLines: 2,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          IPORow(label: "Type", value: ipo.isSme ? 'SME' : 'Mainboard'),
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
          // Label (fixed)
          Text(label, style: const TextStyle(color: Colors.grey)),

          const SizedBox(width: 8),

          // Value (flexible)
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
