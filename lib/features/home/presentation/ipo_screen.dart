import 'package:cupcake/features/algorithm_engine/data/providers/ipo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IpoScreen extends ConsumerWidget {
  const IpoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipoAsync = ref.watch(ipoProvider);
    final filter = ref.watch(ipoFilterProvider);
    final search = ref.watch(searchProvider);
    final sortLatest = ref.watch(sortProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("IPO Tracker"),
        actions: [
          IconButton(
            icon: Icon(sortLatest ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () =>
                ref.read(sortProvider.notifier).state = !sortLatest,
          )
        ],
      ),
      body: Column(
        children: [
          _searchBar(ref),
          _filterChips(ref, filter),
          Expanded(
            child: ipoAsync.when(
              data: (ipo) {
                final list = _applyFilter(
                  ipo,
                  filter,
                  search,
                  sortLatest,
                );

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _ipoCard(list[i]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 Search Bar
  Widget _searchBar(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search IPO...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onChanged: (val) =>
            ref.read(searchProvider.notifier).state = val,
      ),
    );
  }

  // 🎯 Filter Chips
  Widget _filterChips(WidgetRef ref, String selected) {
    final filters = ['upcoming', 'active', 'listed', 'closed'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: filters.map((f) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ChoiceChip(
              label: Text(f.toUpperCase()),
              selected: selected == f,
              onSelected: (_) =>
                  ref.read(ipoFilterProvider.notifier).state = f,
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🧠 Filter Logic
  List _applyFilter(ipo, String filter, String search, bool latest) {
    List list;

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

    // Search
    if (search.isNotEmpty) {
      list = list
          .where((e) =>
              e.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    // Sort by date
    list.sort((a, b) {
      final aDate = a.listingDate ?? DateTime(2000);
      final bDate = b.listingDate ?? DateTime(2000);
      return latest ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
    });

    return list;
  }

  // 🎨 Beautiful IPO Card
  Widget _ipoCard(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff1e3c72), Color(0xff2a5298)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.symbol,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.status.name.toUpperCase(),
                style: const TextStyle(color: Colors.orangeAccent),
              ),
              Text(
                item.listingDate?.toString().split(' ')[0] ?? 'TBA',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          )
        ],
      ),
    );
  }
}
