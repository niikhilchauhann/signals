import 'package:cupcake/features/algorithm_engine/data/models/ipo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/export.dart';
import '../../algorithm_engine/data/providers/other_assets_provider.dart';

class IpoScreen extends ConsumerWidget {
  const IpoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipoAsync = ref.watch(ipoProvider);
    final filter = ref.watch(ipoFilterProvider);
    final search = ref.watch(searchProvider);
    final sortLatest = ref.watch(sortProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFEFF3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _Header(
                sortLatest: sortLatest,
                onToggleSort: () {
                  ref.read(sortProvider.notifier).state = !sortLatest;
                },
              ),
              _searchBar(ref),
              _filterChips(ref, filter),
              Expanded(
                child: ipoAsync.when(
                  data: (ipo) {
                    final list = _applyFilter(ipo, filter, search, sortLatest);

                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: _StatsRow(ipo: ipo)),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == list.length - 1 ? 0 : 12,
                                ),
                                child: _IpoCard(item: list[index]),
                              );
                            }, childCount: list.length),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(e.toString())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool sortLatest;
  final VoidCallback onToggleSort;

  const _Header({required this.sortLatest, required this.onToggleSort});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IPO Tracker', style: AppTextTheme.size24Bold),
              const SizedBox(height: 4),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onToggleSort,
            tooltip: sortLatest ? 'Sort: Latest first' : 'Sort: Oldest first',
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                sortLatest ? Icons.south_rounded : Icons.north_rounded,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔍 Search Bar
Widget _searchBar(WidgetRef ref) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Search by name or symbol",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E7F3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E7F3)),
        ),
      ),
      onChanged: (val) => ref.read(searchProvider.notifier).state = val,
    ),
  );
}

// 🎯 Filter Chips
Widget _filterChips(WidgetRef ref, String selected) {
  final filters = [
    ('upcoming', Icons.watch_later_rounded),
    ('active', Icons.trending_up_rounded),
    ('listed', Icons.check_circle_rounded),
    ('closed', Icons.lock_clock_rounded),
  ];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
    child: Row(
      children: filters.map((f) {
        final isSelected = selected == f.$1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  f.$2,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.darkGrey,
                ),
                const SizedBox(width: 6),
                Text(f.$1.toUpperCase()),
              ],
            ),
            selected: isSelected,
            selectedColor: AppColors.primaryPurple,
            backgroundColor: Colors.white,
            labelStyle: AppTextTheme.size12Bold.copyWith(
              color: isSelected ? Colors.white : AppColors.darkGrey,
            ),
            side: BorderSide(
              color: isSelected
                  ? AppColors.primaryPurple
                  : const Color(0xFFE3E7F3),
            ),
            onSelected: (_) =>
                ref.read(ipoFilterProvider.notifier).state = f.$1,
          ),
        );
      }).toList(),
    ),
  );
}

// 🧠 Filter Logic
List<IPOModel> _applyFilter(
  IpoList ipo,
  String filter,
  String search,
  bool latest,
) {
  List<IPOModel> list;

  switch (filter) {
    case 'active':
      list = ipo.active;
      break;
    case 'listed':
      list = ipo.listed;
      break;
    case 'closed':
      list = ipo.closed;
      break;
    default:
      list = ipo.upcoming;
  }

  if (search.isNotEmpty) {
    list = list
        .where(
          (e) =>
              e.name.toLowerCase().contains(search.toLowerCase()) ||
              e.symbol.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();
  }

  list.sort((a, b) {
    final aDate = a.listingDate ?? DateTime(2000);
    final bDate = b.listingDate ?? DateTime(2000);
    return latest ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
  });

  return list;
}

class _StatsRow extends StatelessWidget {
  final IpoList ipo;

  const _StatsRow({required this.ipo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
      child: Row(
        children: [
          _StatCard(
            label: 'Upco..',
            value: ipo.upcoming.length,
            color: AppColors.primaryPurple,
            icon: Icons.schedule_rounded,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Active',
            value: ipo.active.length,
            color: AppColors.green,
            icon: Icons.bolt_rounded,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Listed',
            value: ipo.listed.length,
            color: AppColors.secondaryViolet,
            icon: Icons.check_circle_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3E7F3)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$value', style: AppTextTheme.size18Bold),
                Text(
                  label,
                  style: AppTextTheme.size12Normal.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IpoCard extends StatelessWidget {
  final IPOModel item;

  const _IpoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);
    final boardColor = item.isSme ? AppColors.hotPink : AppColors.primaryPurple;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF3F6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E7F3)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
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
                    Text(item.name, style: AppTextTheme.size18Bold),
                    const SizedBox(height: 4),
                    Text(
                      item.symbol,
                      style: AppTextTheme.size14Normal.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              _Chip(label: item.status.label, color: statusColor),
              const SizedBox(width: 8),
              _Chip(label: item.isSme ? 'SME' : 'Mainboard', color: boardColor),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Metric(
                label: 'Bidding',
                value: _dateRange(item.biddingStartDate, item.biddingEndDate),
              ),
              _Metric(label: 'Listing', value: _formatDate(item.listingDate)),
              _Metric(label: 'Price Band', value: _priceBand(item)),
              _Metric(
                label: 'Lot Size',
                value: item.lotSize != null ? '${item.lotSize} shares' : '—',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF2FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up_rounded, color: statusColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.additionalText.isNotEmpty
                        ? item.additionalText
                        : 'No highlights shared yet.',
                    style: AppTextTheme.size14Normal.copyWith(
                      color: AppColors.darkGrey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _SentimentPill(label: 'GMP', value: item.gmp ?? '—'),
              const SizedBox(width: 8),
              _SentimentPill(
                label: 'Sentiment',
                value: item.sentiment ?? 'Neutral',
              ),
              const SizedBox(width: 8),
              _SentimentPill(
                label: 'Confidence',
                value: item.confidence ?? '—',
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(label, style: AppTextTheme.size12Bold.copyWith(color: color)),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E7F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextTheme.size12Normal.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTextTheme.size14Bold),
        ],
      ),
    );
  }
}

class _SentimentPill extends StatelessWidget {
  final String label;
  final String value;

  const _SentimentPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final color = _sentimentColor(value);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextTheme.size12Normal.copyWith(
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTextTheme.size12Bold.copyWith(color: color)),
        ],
      ),
    );
  }
}

Color _statusColor(Status status) {
  switch (status) {
    case Status.ACTIVE:
      return AppColors.green;
    case Status.LISTED:
      return AppColors.secondaryViolet;
    case Status.CLOSED:
      return AppColors.grey;
    case Status.UPCOMING:
    default:
      return AppColors.primaryPurple;
  }
}

Color _sentimentColor(String? sentiment) {
  switch (sentiment?.toLowerCase()) {
    case 'positive':
    case 'bullish':
      return AppColors.green;
    case 'negative':
    case 'bearish':
      return AppColors.redLight;
    default:
      return AppColors.secondaryViolet;
  }
}

String _formatDate(DateTime? date) {
  if (date == null) return '—';
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _dateRange(DateTime? start, DateTime? end) {
  final startStr = _formatDate(start);
  final endStr = _formatDate(end);
  if (startStr == '—' && endStr == '—') return 'TBA';
  if (startStr != '—' && endStr != '—') return '$startStr → $endStr';
  return startStr != '—' ? startStr : endStr;
}

String _priceBand(IPOModel item) {
  if (item.minPrice != null && item.maxPrice != null) {
    return '${item.minPrice!.toStringAsFixed(0)} - ${item.maxPrice!.toStringAsFixed(0)}';
  }
  if (item.issuePrice != null) {
    return 'Rs ${item.issuePrice!.toStringAsFixed(0)}';
  }
  return '—';
}
