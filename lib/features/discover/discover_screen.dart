import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/export.dart';

final yourActivitiesIndexProvider = StateProvider<int>((ref) => 0);

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.grey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediaQuery.of(context).padding.top.heightBox,
          20.heightBox,
          Text('Your Activities', style: AppTextTheme.size20Bold).px(16),
          24.heightBox,
          // Expanded(
          //   child: CustomTabSwitcher(
          //     // initialIndex: index,
          //     indexProvider: yourActivitiesIndexProvider,
          //     tabs: ['Requests Sent', 'Requests Received'],
          //     tabWidgets: [
                
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
