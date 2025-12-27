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
    LensScreen(),
    WatchlistScreen()
  ];

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
            onTap: (index) => setState(() => _currentIndex.value = index),
            backgroundColor: AppColors.white,
            selectedColor: AppColors.black,
            unSelectedColor: AppColors.black.withValues(alpha: 0.5),
            strokeColor: AppColors.primaryPurple.withValues(alpha: 0.1),
            elevation: 4,
            items: [
              CustomNavigationBarItem(
                icon: Icon(
                  // _currentIndex.value == 0
                  //     ?
                  Icons.home_filled,
                  // : Icons.home_outlined,
                ),
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
                icon: Icon(
                  // _currentIndex.value == 1
                  //     ? Icons.account_balance_wallet
                  //     :
                  Icons.explore_outlined,
                ),
                title: Text(
                  'Discover',
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
                  'Plus',
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
                icon: Icon(
                  // _currentIndex.value == 3
                  //     ? CupertinoIcons.person_crop_circle_fill
                  // :
                  Icons.legend_toggle_sharp,
                ),
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
