import 'package:flutter/material.dart';

import '../../core/export.dart';
import 'discover_repository.dart';

class ArticleDetailScreen extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
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
                  0,
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
                      child: Text(
                        article.category,
                        style: AppTextTheme.size14Normal.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Title
                      Text(article.title, style: AppTextTheme.size24Bold),
                      const SizedBox(height: 8),
                      Text(
                        article.subtitle,
                        style: AppTextTheme.size14Normal.copyWith(
                          color: AppColors.grey,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Meta row
                      Row(
                        children: [
                          _MetaChip(
                            icon: Icons.schedule_rounded,
                            label: '${article.readingTimeMinutes} min read',
                          ),
                          const SizedBox(width: 8),
                          _DifficultyChip(difficulty: article.difficulty),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sectionGap),

                      // Sections
                      ...article.sections.map(
                        (section) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.sectionGap,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.heading,
                                style: AppTextTheme.size18Bold,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                section.body,
                                style: AppTextTheme.size14Normal.copyWith(
                                  color: AppColors.darkGrey,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Educational disclaimer
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 16, color: AppColors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This content is for educational purposes only and does not constitute financial advice.',
                                style: AppTextTheme.size12Normal.copyWith(
                                  color: AppColors.darkGrey,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.grey),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextTheme.size12Normal.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final Difficulty difficulty;

  const _DifficultyChip({required this.difficulty});

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextTheme.size12Normal.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
