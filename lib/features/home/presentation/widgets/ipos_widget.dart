import 'package:cupcake/core/global_widgets/custom_text_button.dart';
import 'package:cupcake/features/home/presentation/ipo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/home_screen_providers.dart';
import '/config/theme/app_text_theme.dart';

import '/core/extensions/app_extensions.dart';
import 'package:flutter/material.dart';

class TopIPOsSection extends ConsumerWidget {
  const TopIPOsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipos = ref.watch(ipoWithGmpProvider);
    final refresh = ref.read(ipoRefreshProvider);

    return ipos.when(
      loading: () => Center(child: const CircularProgressIndicator()).py(32),
      error: (ob, st) {
        print("IPO Fetch Error - $ob - $st");
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
                    await ref.read(ipoWithGmpProvider.future);
                  },
                  title: 'Refresh',
                ),
                CustomTextButton(
                  ontap: () async {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => const IpoScreen()));
                  },
                  title: 'See All',
                ),
                16.widthBox,
              ],
            ),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final ipo = data[index];
                  return IpoCard(
                    name: ipo.name,
                    gmp: ipo.gmp,
                    subscribed: ipo.subscription,
                    dates: ipo.dates,
                    type: ipo.type,
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
  final String name;
  final String gmp;
  final String subscribed;
  final String dates;
  final String type;

  const IpoCard({
    super.key,
    required this.name,
    required this.gmp,
    required this.subscribed,
    required this.dates,
    required this.type,
  });

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
            name,
            maxLines: 2,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          IPORow(label: "GMP", value: gmp),
          IPORow(label: "Subscribed", value: "${subscribed}x"),
          IPORow(label: "Dates", value: dates),
          IPORow(label: "Type", value: type),
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
