import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import '../features/discover/discover_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/lens/lens_screen.dart';
import '../features/watchlist/watchlist_screen.dart';
import 'export.dart';

class AppStructure extends StatefulWidget {
  const AppStructure({super.key});

  @override
  State<AppStructure> createState() => _AppStructureState();
}

class _AppStructureState extends State<AppStructure> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  List<Widget> screens = [
    HomeScreen(),
    DiscoverScreen(),
    SizedBox(), // placeholder — center button opens modal
    LensScreen(),
    WatchlistScreen(),
  ];

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  void _showAppInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AppInfoSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _currentIndex,
      builder: (context, value, child) => Scaffold(
        body: IndexedStack(index: _currentIndex.value, children: screens),
        bottomNavigationBar: SizedBox(
          height: 75,
          child: CustomNavigationBar(
            currentIndex: value,
            onTap: (index) {
              if (index == 2) {
                _showAppInfoModal(context);
              } else {
                _currentIndex.value = index;
              }
            },
            backgroundColor: AppColors.white,
            selectedColor: AppColors.black,
            unSelectedColor: AppColors.black.withValues(alpha: 0.5),
            strokeColor: AppColors.primaryPurple.withValues(alpha: 0.1),
            elevation: 4,
            items: [
              CustomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                title: Text(
                  'Home',
                  style: AppTextTheme.size12Normal.copyWith(
                    height: 1.6,
                    color: _currentIndex.value == 0
                        ? null
                        : AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                title: Text(
                  'Learn',
                  style: AppTextTheme.size12Normal.copyWith(
                    height: 1.6,
                    color: _currentIndex.value == 1
                        ? null
                        : AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: CustomRoundButton(
                  btnColor: AppColors.primaryPurple,
                  iconColor: AppColors.white,
                  icon: Icons.bolt,
                ),
                title: Text(
                  'Signals',
                  style: AppTextTheme.size12Normal.copyWith(
                    height: 2,
                    color: _currentIndex.value == 2
                        ? null
                        : AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.lens_blur),
                title: Text(
                  'Lens',
                  style: AppTextTheme.size12Normal.copyWith(
                    height: 1.6,
                    color: _currentIndex.value == 3
                        ? null
                        : AppColors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.legend_toggle_sharp),
                title: Text(
                  'Watchlist',
                  style: AppTextTheme.size12Normal.copyWith(
                    height: 1.6,
                    color: _currentIndex.value == 4
                        ? null
                        : AppColors.black.withValues(alpha: 0.5),
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

class _AppInfoSheet extends StatelessWidget {
  const _AppInfoSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          // App logo / icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryPurple.withValues(alpha: 0.2),
              ),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.primaryPurple,
              size: 32,
            ),
          ),

          const SizedBox(height: 16),

          // App name
          Text('Signals', style: AppTextTheme.size24Bold),
          const SizedBox(height: 4),
          Text(
            'Analyze. Trade. Learn.',
            style: AppTextTheme.size14Normal.copyWith(color: AppColors.grey),
          ),

          const SizedBox(height: 8),

          // Version badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              'Version 1.0.0',
              style: AppTextTheme.size12Normal.copyWith(
                color: AppColors.darkGrey,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Features
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card(shadow: AppShadows.none),
              child: Column(
                children: const [
                  _FeatureRow(
                    icon: Icons.auto_graph_rounded,
                    title: 'Smart Trade Setups',
                    subtitle: 'AI-powered technical analysis signals',
                  ),
                  SizedBox(height: 12),
                  _FeatureRow(
                    icon: Icons.trending_up_rounded,
                    title: 'IPO Tracker',
                    subtitle: 'Live GMP, sentiment & confidence scores',
                  ),
                  SizedBox(height: 12),
                  _FeatureRow(
                    icon: Icons.lens_blur,
                    title: 'Chart Lens AI',
                    subtitle: 'Upload charts for instant analysis',
                  ),
                  SizedBox(height: 12),
                  _FeatureRow(
                    icon: Icons.school_rounded,
                    title: 'Market Education',
                    subtitle: 'Learn patterns, strategies & concepts',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Disclaimer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(
                  color: AppColors.red.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.red.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This app is for educational and informational purposes only. '
                      'It does not constitute financial advice, investment recommendation, '
                      'or solicitation. Always consult a SEBI-registered financial advisor '
                      'before making investment decisions. Past performance does not '
                      'guarantee future results. Trading involves substantial risk of loss.',
                      style: AppTextTheme.size12Normal.copyWith(
                        color: AppColors.darkGrey,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextTheme.size14Bold),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextTheme.size12Normal.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
