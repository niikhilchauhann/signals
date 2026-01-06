import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../algorithm_engine/data/models/uni_stock_model.dart';
import '../algorithm_engine/data/providers/stock_lists_provider.dart';
import 'watchlist_provider.dart'; 

// Chip options
enum ChipSource { watchlist, trending, nseActive, bseActive, week52, priceShockers }

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  ChipSource _selected = ChipSource.watchlist;
  String _search = '';

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
            trendingStocks.topGainers.map((x) => x as StockModel));
        final List<StockModel> losers = List<StockModel>.from(
            trendingStocks.topLosers.map((x) => x as StockModel));
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
          items.add(StockModel(
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
          ));
        }

        for (final e in bse.low52Week) {
          items.add(StockModel(
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
          ));
        }

        // same for NSE lists
        for (final e in nse.high52Week) {
          items.add(StockModel(
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
          ));
        }
        for (final e in nse.low52Week) {
          items.add(StockModel(
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
          ));
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
        .where((s) =>
            s.tickerId.toLowerCase().contains(ql) ||
            s.companyName.toLowerCase().contains(ql))
        .toList();
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
          final match =
              nseList.firstWhere((x) => x.tickerId == symbol, orElse: () => bseList.firstWhere((x) => x.tickerId == symbol, orElse: () => StockModel(
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
              )));
          mapped.add(match);
        }
        visible = mapped;
        break;

      case ChipSource.trending:
        visible = _extractFromTrending(trending);
        break;

      case ChipSource.nseActive:
        visible = nseActive.when(
            data: (d) => d, loading: () => [], error: (e, s) => []);
        break;

      case ChipSource.bseActive:
        visible = bseActive.when(
            data: (d) => d, loading: () => [], error: (e, s) => []);
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
            error: (e, s) => []);
        break;
    }

    // apply search filter
    final filtered = _applySearch(visible, _search);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search symbol or company',
                  border: InputBorder.none,
                  fillColor: Colors.grey[100],
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () async {
                // Add symbol flow: show dialog for manual add
                final sym = await showDialog<String>(
                  context: context,
                  builder: (ctx) {
                    String s = '';
                    return AlertDialog(
                      title: const Text('Add symbol'),
                      content: TextField(
                        decoration:
                            const InputDecoration(hintText: 'Enter ticker id'),
                        onChanged: (v) => s = v.trim().toUpperCase(),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, null),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, s),
                            child: const Text('Add')),
                      ],
                    );
                  },
                );

                if (sym != null && sym.isNotEmpty) {
                  await ref.read(watchlistProvider.notifier).add(sym);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Symbol'),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: Column(
        children: [
          // chips row
          SizedBox(
            height: 56,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              children: ChipSource.values.map((c) {
                final selected = c == _selected;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(_chipLabel(c)),
                    selected: selected,
                    onSelected: (sel) {
                      if (sel) {
                        setState(() {
                        _selected = c;
                        _search = '';
                      });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // list header similar spacing as screenshot
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.list_alt, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          _selected == ChipSource.watchlist
                              ? 'Your watchlist is empty.\nSearch or use chips to add symbols.'
                              : 'No results.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final st = filtered[index];
                      final inWatch = ref
                          .watch(watchlistProvider)
                          .contains(st.tickerId);

                      final chgText = st.percentChange.isNotEmpty
                          ? st.percentChange
                          : st.netChange;

                      double? pct;
                      try {
                        pct = double.tryParse(
                                st.percentChange.replaceAll('%', '')) ??
                            double.tryParse(st.netChange.replaceAll('%', ''));
                      } catch (_) {
                        pct = null;
                      }

                      final Color pctColor =
                          (pct != null && pct < 0) ? Colors.red : Colors.green;

                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    st.tickerId,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    st.companyName,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  st.price.isNotEmpty ? st.price : '-',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  chgText.isNotEmpty ? chgText : '-',
                                  style: TextStyle(
                                    color: pctColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: Icon(
                                inWatch ? Icons.check_circle : Icons.add_circle_outline,
                                color: inWatch ? Colors.green : Colors.grey[700],
                              ),
                              onPressed: () async {
                                final notifier = ref.read(watchlistProvider.notifier);
                                if (inWatch) {
                                  await notifier.remove(st.tickerId);
                                } else {
                                  await notifier.add(st.tickerId);
                                }
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
