import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/export.dart';
import 'discover_repository.dart';
import 'learn_charts_screen.dart';
import 'article_detail_screen.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final ValueNotifier<String> _search = ValueNotifier('');

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _search,
      builder: (context, searchValue, child) {
        final categories = ref.watch(categoriesProvider);
        final featured = ref.watch(featuredArticlesProvider);

        final filteredCategories = searchValue.isEmpty
            ? categories
            : categories
                .where(
                  (c) =>
                      c.name.toLowerCase().contains(searchValue.toLowerCase()) ||
                      c.subtitle.toLowerCase().contains(searchValue.toLowerCase()),
                )
                .toList();

        return Scaffold(
          body: Container(
            decoration: AppDecorations.screenBackground,
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        12,
                        AppSpacing.screenPadding,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Learn', style: AppTextTheme.size24Bold),
                          const SizedBox(height: 4),
                          Text(
                            'Master the markets with curated guides',
                            style: AppTextTheme.size14Normal.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Search bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.itemGap,
                        AppSpacing.screenPadding,
                        0,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search topics...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.input),
                            borderSide: BorderSide(color: AppColors.cardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadius.input),
                            borderSide: BorderSide(color: AppColors.cardBorder),
                          ),
                        ),
                        onChanged: (val) => _search.value = val,
                      ),
                    ),
                  ),

                  // Learn Charts card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.sectionGap,
                        AppSpacing.screenPadding,
                        0,
                      ),
                      child: _LearnChartsCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const LearnChartsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Featured articles
                  if (searchValue.isEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          AppSpacing.sectionGap,
                          AppSpacing.screenPadding,
                          AppSpacing.itemGap,
                        ),
                        child: Text('Featured', style: AppTextTheme.size18Bold),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenPadding,
                          ),
                          itemCount: featured.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSpacing.itemGap),
                          itemBuilder: (context, index) {
                            return _FeaturedCard(
                              article: featured[index],
                              onTap: () => _openArticle(context, featured[index]),
                            );
                          },
                        ),
                      ),
                    ),
                  ],

                  // Categories section header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.sectionGap,
                        AppSpacing.screenPadding,
                        AppSpacing.itemGap,
                      ),
                      child: Text('All Topics', style: AppTextTheme.size18Bold),
                    ),
                  ),

                  // Categories grid
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      24,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                        crossAxisSpacing: AppSpacing.itemGap,
                        mainAxisSpacing: AppSpacing.itemGap,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final cat = filteredCategories[index];
                          return _CategoryCard(
                            category: cat,
                            onTap: () => _openCategory(context, ref, cat),
                          );
                        },
                        childCount: filteredCategories.length,
                      ),
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

  void _openCategory(
    BuildContext context,
    WidgetRef ref,
    ArticleCategory category,
  ) {
    final repo = ref.read(articleRepositoryProvider);
    final articles = repo.getArticlesForCategory(category.name);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => _CategoryScreen(
          category: category,
          articles: articles,
        ),
      ),
    );
  }

  void _openArticle(BuildContext context, ArticleModel article) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Learn Charts Card
// ─────────────────────────────────────────

class _LearnChartsCard extends StatelessWidget {
  final VoidCallback onTap;

  const _LearnChartsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.cardLarge),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: AppDecorations.card(radius: AppRadius.cardLarge),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.candlestick_chart_rounded,
                color: AppColors.primaryPurple,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Learn Charts', style: AppTextTheme.size18Bold),
                  const SizedBox(height: 4),
                  Text(
                    'Chart patterns & candlestick patterns with visual guides',
                    style: AppTextTheme.size12Normal.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Featured Article Card
// ─────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const _FeaturedCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(14),
        decoration: AppDecorations.card(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(article.icon,
                      color: AppColors.primaryPurple, size: 18),
                ),
                const Spacer(),
                _DifficultyBadge(difficulty: article.difficulty),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              article.title,
              style: AppTextTheme.size14Bold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.schedule_rounded,
                    size: 12, color: AppColors.grey),
                const SizedBox(width: 4),
                Text(
                  '${article.readingTimeMinutes} min',
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

// ─────────────────────────────────────────
// Category Card
// ─────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final ArticleCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppDecorations.card(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(category.icon,
                  color: AppColors.primaryPurple, size: 18),
            ),
            const Spacer(),
            Text(
              category.name,
              style: AppTextTheme.size14Bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              category.subtitle,
              style: AppTextTheme.size12Normal.copyWith(
                color: AppColors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Difficulty Badge
// ─────────────────────────────────────────

class _DifficultyBadge extends StatelessWidget {
  final Difficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (difficulty) {
      case Difficulty.beginner:
        color = AppColors.green;
        label = 'Beginner';
        break;
      case Difficulty.intermediate:
        color = AppColors.yellow;
        label = 'Intermediate';
        break;
      case Difficulty.advanced:
        color = AppColors.redLight;
        label = 'Advanced';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextTheme.size10Normal.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Category Screen (articles list)
// ─────────────────────────────────────────

class _CategoryScreen extends StatelessWidget {
  final ArticleCategory category;
  final List<ArticleModel> articles;

  const _CategoryScreen({
    required this.category,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppDecorations.screenBackground,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  8,
                  AppSpacing.screenPadding,
                  AppSpacing.sectionGap,
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
                        child:
                            const Icon(Icons.arrow_back_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: AppTextTheme.size20Bold,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            category.subtitle,
                            style: AppTextTheme.size12Normal.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Articles list
              Expanded(
                child: articles.isEmpty
                    ? Center(
                        child: Text(
                          'Articles coming soon',
                          style: AppTextTheme.size16Bold.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          0,
                          AppSpacing.screenPadding,
                          24,
                        ),
                        itemCount: articles.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.itemGap),
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return _ArticleListCard(
                            article: article,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => ArticleDetailScreen(
                                    article: article,
                                  ),
                                ),
                              );
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
}

class _ArticleListCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const _ArticleListCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: AppDecorations.card(),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(article.icon,
                  color: AppColors.primaryPurple, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: AppTextTheme.size16Bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.subtitle,
                    style: AppTextTheme.size12Normal.copyWith(
                      color: AppColors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 12, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${article.readingTimeMinutes} min read',
                        style: AppTextTheme.size10Normal.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _DifficultyBadge(difficulty: article.difficulty),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
