
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/export.dart';
import '../algorithm_engine/data/models/uni_stock_model.dart';
import '../algorithm_engine/data/providers/stock_lists_provider.dart';
import 'domain/repository/watchlist_provider.dart';

// Chip options
enum ChipSource {
  watchlist,
  trending,
  nseActive,
  bseActive,
  week52,
  priceShockers,
}

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  ChipSource _selected = ChipSource.watchlist;
  String _search = '';
  final TextEditingController _searchCtrl = TextEditingController();

  // helpers for display text
  String _chipLabel(ChipSource c) {
    switch (c) {
      case ChipSource.watchlist:
        return 'Watchlist';
      case ChipSource.trending:
        return 'Trending';
      case ChipSource.nseActive:
        return 'NSE Active';
      case ChipSource.bseActive:
        return 'BSE Active';
      case ChipSource.week52:
        return '52 Week';
      case ChipSource.priceShockers:
        return 'Price Shockers';
    }
  }

  // unify a StockModel list from all providers (some providers return wrapper types)
  List<StockModel> _extractFromTrending(AsyncValue trending) {
    if (trending is AsyncData) {
      final value = trending.value as dynamic;
      // TrendingStockResponse -> TrendingStocks (topGainers/topLosers)
      try {
        final trendingStocks = value.trendingStocks;
        final List<StockModel> gainers = List<StockModel>.from(
          trendingStocks.topGainers.map((x) => x as StockModel),
        );
        final List<StockModel> losers = List<StockModel>.from(
          trendingStocks.topLosers.map((x) => x as StockModel),
        );
        return [...gainers, ...losers];
      } catch (_) {
        return [];
      }
    } else {
      return [];
    }
  }

  // When Week52 is selected, we map Week52High/Low into StockModel-like rows for display.
  List<StockModel> _extractFromWeek52(AsyncValue week52Val) {
    if (week52Val is AsyncData) {
      final value = week52Val.value as dynamic; // Week52Response
      try {
        final List<StockModel> items = [];
        final bse = value.bse;
        final nse = value.nse;

        // map high52Week list
        for (final e in bse.high52Week) {
          items.add(
            StockModel(
              tickerId: e.ticker ?? '',
              companyName: e.company ?? '',
              price: e.price.toString(),
              percentChange: '',
              netChange: '',
              bid: '',
              ask: '',
              high: e.high52Week.toString(),
              low: '',
              open: '',
              lowCircuitLimit: '',
              upCircuitLimit: '',
              volume: '',
              close: '',
              overallRating: '',
              shortTermTrends: '',
              longTermTrends: '',
              yearLow: '',
              yearHigh: e.high52Week.toString(),
            ),
          );
        }

        for (final e in bse.low52Week) {
          items.add(
            StockModel(
              tickerId: e.ticker ?? '',
              companyName: e.company ?? '',
              price: e.price.toString(),
              percentChange: '',
              netChange: '',
              bid: '',
              ask: '',
              high: '',
              low: e.low52Week.toString(),
              open: '',
              lowCircuitLimit: '',
              upCircuitLimit: '',
              volume: '',
              close: '',
              overallRating: '',
              shortTermTrends: '',
              longTermTrends: '',
              yearLow: e.low52Week.toString(),
              yearHigh: '',
            ),
          );
        }

        // same for NSE lists
        for (final e in nse.high52Week) {
          items.add(
            StockModel(
              tickerId: e.ticker ?? '',
              companyName: e.company ?? '',
              price: e.price.toString(),
              percentChange: '',
              netChange: '',
              bid: '',
              ask: '',
              high: e.high52Week.toString(),
              low: '',
              open: '',
              lowCircuitLimit: '',
              upCircuitLimit: '',
              volume: '',
              close: '',
              overallRating: '',
              shortTermTrends: '',
              longTermTrends: '',
              yearLow: '',
              yearHigh: e.high52Week.toString(),
            ),
          );
        }
        for (final e in nse.low52Week) {
          items.add(
            StockModel(
              tickerId: e.ticker ?? '',
              companyName: e.company ?? '',
              price: e.price.toString(),
              percentChange: '',
              netChange: '',
              bid: '',
              ask: '',
              high: '',
              low: e.low52Week.toString(),
              open: '',
              lowCircuitLimit: '',
              upCircuitLimit: '',
              volume: '',
              close: '',
              overallRating: '',
              shortTermTrends: '',
              longTermTrends: '',
              yearLow: e.low52Week.toString(),
              yearHigh: '',
            ),
          );
        }

        return items;
      } catch (_) {
        return [];
      }
    } else {
      return [];
    }
  }

  // generic filter by search text
  List<StockModel> _applySearch(List<StockModel> items, String q) {
    if (q.isEmpty) return items;
    final ql = q.toLowerCase();
    return items
        .where(
          (s) =>
              s.tickerId.toLowerCase().contains(ql) ||
              s.companyName.toLowerCase().contains(ql),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchlist = ref.watch(watchlistProvider);
    final trending = ref.watch(trendingStockProvider);
    final nseActive = ref.watch(nseMostActiveProvider);
    final bseActive = ref.watch(bseMostActiveProvider);
    final week52 = ref.watch(week52Provider);
    final priceShockers = ref.watch(priceShockerProvider);

    // build the visible item list based on selected chip
    List<StockModel> visible = [];

    switch (_selected) {
      case ChipSource.watchlist:
        // for watchlist, fetch details by symbol from NSE/NSE active providers if available,
        // otherwise create minimal rows with symbol only.
        List<StockModel> mapped = [];

        // try matching against nseActive and bseActive results
        final nseList = nseActive.when(
          data: (d) => d,
          loading: () => [],
          error: (e, s) => [],
        );
        final bseList = bseActive.when(
          data: (d) => d,
          loading: () => [],
          error: (e, s) => [],
        );

        for (final symbol in watchlist) {
          StockModel match;

          try {
            match = nseList.firstWhere((x) => x.tickerId == symbol);
          } catch (_) {
            try {
              match = bseList.firstWhere((x) => x.tickerId == symbol);
            } catch (_) {
              match = StockModel(
                tickerId: symbol,
                companyName: symbol,
                price: '',
                percentChange: '',
                netChange: '',
                bid: '',
                ask: '',
                high: '',
                low: '',
                open: '',
                lowCircuitLimit: '',
                upCircuitLimit: '',
                volume: '',
                close: '',
                overallRating: '',
                shortTermTrends: '',
                longTermTrends: '',
                yearLow: '',
                yearHigh: '',
              );
            }
          }

          mapped.add(match);
        }
        visible = mapped;
        break;

      case ChipSource.trending:
        visible = _extractFromTrending(trending);
        break;

      case ChipSource.nseActive:
        visible = nseActive.when(
          data: (d) => d,
          loading: () => [],
          error: (e, s) => [],
        );
        break;

      case ChipSource.bseActive:
        visible = bseActive.when(
          data: (d) => d,
          loading: () => [],
          error: (e, s) => [],
        );
        break;

      case ChipSource.week52:
        visible = _extractFromWeek52(week52);
        break;

      case ChipSource.priceShockers:
        visible = priceShockers.when(
          data: (d) {
            // PriceShockerResponse -> parse a list; if your PriceShockerResponse
            // provides a list field replace this accordingly.
            try {
              final list = d.stocks as List<StockModel>;
              return list;
            } catch (_) {
              return <StockModel>[];
            }
          },
          loading: () => [],
          error: (e, s) => [],
        );
        break;
    }

    // apply search filter
    final filtered = _applySearch(visible, _search);

    // track loading state per source to avoid showing empty UI while fetching
    final bool isLoading = () {
      switch (_selected) {
        case ChipSource.trending:
          return trending.isLoading;
        case ChipSource.nseActive:
          return nseActive.isLoading;
        case ChipSource.bseActive:
          return bseActive.isLoading;
        case ChipSource.week52:
          return week52.isLoading;
        case ChipSource.priceShockers:
          return priceShockers.isLoading;
        case ChipSource.watchlist:
        default:
          return false;
      }
    }();

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
          child: Column(
            children: [
              _Header(
                controller: _searchCtrl,
                onSearch: (v) => setState(() => _search = v),
                onAddSymbol: () => _openAddSymbolDialog(context, ref),
              ),
              _ChipsRow(
                selected: _selected,
                labelBuilder: _chipLabel,
                onSelected: (c) => setState(() {
                  _selected = c;
                  _search = '';
                  _searchCtrl.clear();
                }),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                    ? _EmptyState(
                        isWatchlist: _selected == ChipSource.watchlist,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final st = filtered[index];
                          final inWatch = ref
                              .watch(watchlistProvider)
                              .contains(st.tickerId);
                          final chgText = st.percentChange;

                          double? pct;
                          try {
                            pct =
                                double.tryParse(
                                  st.percentChange.replaceAll('%', ''),
                                ) ??
                                double.tryParse(
                                  st.netChange.replaceAll('%', ''),
                                );
                          } catch (_) {
                            pct = null;
                          }

                          final Color pctColor = (pct != null && pct < 0)
                              ? AppColors.redLight
                              : AppColors.green;

                          return _StockCard(
                            stock: st,
                            changeText: chgText,
                            changeColor: pctColor,
                            inWatchlist: inWatch,
                            onToggleWatch: () async {
                              final notifier = ref.read(
                                watchlistProvider.notifier,
                              );
                              if (inWatch) {
                                await notifier.remove(st.tickerId);
                              } else {
                                await notifier.add(st.tickerId);
                              }
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
  }

  Future<void> _openAddSymbolDialog(BuildContext context, WidgetRef ref) async {
    final sym = await showDialog<String>(
      context: context,
      builder: (ctx) {
        String s = '';
        return AlertDialog(
          title: const Text('Add symbol'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Enter ticker id'),
            onChanged: (v) => s = v.trim().toUpperCase(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, s),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (sym != null && sym.isNotEmpty) {
      await ref.read(watchlistProvider.notifier).add(sym);
    }
  }
}

class _Header extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onAddSymbol;

  const _Header({
    required this.controller,
    required this.onSearch,
    required this.onAddSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Watchlist', style: AppTextTheme.size24Bold),
                  const SizedBox(height: 4),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onAddSymbol,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search symbol or company',
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
            onChanged: onSearch,
          ),
        ],
      ),
    );
  }
}

class _ChipsRow extends StatelessWidget {
  final ChipSource selected;
  final String Function(ChipSource) labelBuilder;
  final ValueChanged<ChipSource> onSelected;

  const _ChipsRow({
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final icons = {
      ChipSource.watchlist: Icons.bookmark_rounded,
      ChipSource.trending: Icons.trending_up_rounded,
      ChipSource.nseActive: Icons.flash_on_rounded,
      ChipSource.bseActive: Icons.electric_bolt_rounded,
      ChipSource.week52: Icons.timeline_rounded,
      ChipSource.priceShockers: Icons.warning_amber_rounded,
    };

    return SizedBox(
      height: 64,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        children: ChipSource.values.map((c) {
          final isSelected = c == selected;
          final color = isSelected
              ? AppColors.primaryPurple
              : const Color(0xFFE3E7F3);
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              avatar: Icon(icons[c], size: 16),
              label: Text(labelBuilder(c)),
              selected: isSelected,
              selectedColor: color,
              backgroundColor: Colors.white,
              side: BorderSide(color: color),
              labelStyle: AppTextTheme.size12Bold.copyWith(
                color: isSelected ? Colors.white : AppColors.darkGrey,
              ),
              onSelected: (_) => onSelected(c),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final StockModel stock;
  final String changeText;
  final Color changeColor;
  final bool inWatchlist;
  final VoidCallback onToggleWatch;

  const _StockCard({
    required this.stock,
    required this.changeText,
    required this.changeColor,
    required this.inWatchlist,
    required this.onToggleWatch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E7F3)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.companyName,
                  style: AppTextTheme.size18Bold,
                  maxLines: 2,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF2FB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    stock.tickerId,
                    style: AppTextTheme.size12Normal.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Pill(label: 'High', value: stock.high),
                    const SizedBox(width: 6),
                    _Pill(label: 'Low', value: stock.low),
                    const SizedBox(width: 6),
                    _Pill(label: 'Bid', value: stock.bid),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${stock.price.isNotEmpty ? stock.price : '-'}',
                style: AppTextTheme.size18Bold,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '± ${changeText.isNotEmpty ? changeText : 'NA'}%',
                  style: AppTextTheme.size12Bold.copyWith(color: changeColor),
                ),
              ),
              // const SizedBox(height: 12),
              IconButton(
                icon: Icon(
                  inWatchlist ? Icons.check_circle : Icons.add_circle_outline,
                  color: inWatchlist ? AppColors.green : AppColors.grey,
                ),
                onPressed: onToggleWatch,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final String value;

  const _Pill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final display = (value.isNotEmpty) ? value : 'NA';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$label: $display',
        style: AppTextTheme.size12Normal.copyWith(color: AppColors.darkGrey),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isWatchlist;

  const _EmptyState({required this.isWatchlist});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.explore_outlined,
              size: 64,
              color: Color(0xFFB0B3C5),
            ),
            const SizedBox(height: 12),
            Text(
              isWatchlist
                  ? 'Your watchlist is empty.'
                  : 'No results in this filter.',
              textAlign: TextAlign.center,
              style: AppTextTheme.size16Bold.copyWith(
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isWatchlist
                  ? 'Search or add symbols to start tracking moves.'
                  : 'Try another filter or search query.',
              textAlign: TextAlign.center,
              style: AppTextTheme.size14Normal.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
