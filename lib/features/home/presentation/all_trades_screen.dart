import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/trade_setup_model.dart';
import '../providers/home_screen_providers.dart';
import '/core/export.dart';
// import '../../data/models/trade_setup_model.dart';
// import '../../providers/home_screen_providers.dart';
import 'widgets/top_stocks_widget.dart';

class AllTradesScreen extends ConsumerStatefulWidget {
  const AllTradesScreen({super.key});

  @override
  ConsumerState<AllTradesScreen> createState() => _AllTradesScreenState();
}

class _TradesState {
  final String filter;
  final String search;
  final bool sortByScore;

  _TradesState({
    this.filter = 'all',
    this.search = '',
    this.sortByScore = true,
  });

  _TradesState copyWith({
    String? filter,
    String? search,
    bool? sortByScore,
  }) {
    return _TradesState(
      filter: filter ?? this.filter,
      search: search ?? this.search,
      sortByScore: sortByScore ?? this.sortByScore,
    );
  }
}

class _AllTradesScreenState extends ConsumerState<AllTradesScreen> {
  final ValueNotifier<_TradesState> _state = ValueNotifier(_TradesState());
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _state.dispose();
    super.dispose();
  }

  List<TradeSetup> _applyFilters(List<TradeSetup> trades, _TradesState state) {
    var result = List<TradeSetup>.from(trades);

    // Apply verdict filter
    if (state.filter != 'all') {
      result = result.where((t) {
        switch (state.filter) {
          case 'buy':
            return t.verdict == TradeVerdict.buy;
          case 'watch':
            return t.verdict == TradeVerdict.watch;
          case 'avoid':
            return t.verdict == TradeVerdict.avoid;
          default:
            return true;
        }
      }).toList();
    }

    // Apply search
    if (state.search.isNotEmpty) {
      final q = state.search.toLowerCase();
      result = result
          .where(
            (t) =>
                t.name.toLowerCase().contains(q) ||
                t.symbol.toLowerCase().contains(q),
          )
          .toList();
    }

    // Sort
    if (state.sortByScore) {
      result.sort((a, b) => b.score.compareTo(a.score));
    } else {
      result.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final tradesAsync = ref.watch(topTradesProvider);

    return ValueListenableBuilder<_TradesState>(
      valueListenable: _state,
      builder: (context, state, child) {
        return Scaffold(
          body: Container(
            decoration: AppDecorations.screenBackground,
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      8,
                      AppSpacing.screenPadding,
                      6,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Trade Setups', style: AppTextTheme.size24Bold),
                            const SizedBox(height: 2),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () =>
                              _state.value = state.copyWith(sortByScore: !state.sortByScore),
                          tooltip: state.sortByScore
                              ? 'Sort: By Score'
                              : 'Sort: Alphabetical',
                          icon: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              state.sortByScore
                                  ? Icons.sort_rounded
                                  : Icons.sort_by_alpha_rounded,
                              color: AppColors.primaryPurple,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: "Search by name or symbol",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          borderSide: BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          borderSide: BorderSide(color: AppColors.cardBorder),
                        ),
                      ),
                      onChanged: (val) => _state.value = state.copyWith(search: val),
                    ),
                  ),

                  // Filter chips
                  _FilterChips(
                    selected: state.filter,
                    onSelected: (f) => _state.value = state.copyWith(filter: f),
                  ),

              // Trade list
              Expanded(
                child: tradesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Failed to load trade setups',
                        style: AppTextTheme.size16Bold.copyWith(
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                  ),
                  data: (data) {
                    final filtered = _applyFilters(data, state);

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: AppColors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No trade setups match your filters',
                              style: AppTextTheme.size16Bold.copyWith(
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.innerGap,
                        AppSpacing.screenPadding,
                        24,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.itemGap),
                      itemBuilder: (context, index) {
                        return TradeCard(trade: filtered[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _FilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final filters = [
      ('all', Icons.dashboard_rounded, 'All'),
      ('buy', Icons.trending_up_rounded, 'Buy'),
      ('watch', Icons.remove_red_eye_outlined, 'Watch'),
      ('avoid', Icons.block_rounded, 'Avoid'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding - 6,
        AppSpacing.itemGap,
        AppSpacing.screenPadding - 6,
        AppSpacing.innerGap,
      ),
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
                  Text(f.$3),
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
                    : AppColors.cardBorder,
              ),
              onSelected: (_) => onSelected(f.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}
