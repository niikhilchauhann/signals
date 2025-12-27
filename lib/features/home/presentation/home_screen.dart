import '/core/export.dart';
import 'package:flutter/material.dart';

import 'widgets/indices_widget.dart';
import 'widgets/ipos_widget.dart';
import 'widgets/top_stocks_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaQuery.of(context).padding.top.heightBox,
            20.heightBox,
            Text('Daily Analysis', style: AppTextTheme.size20Bold).px(16),
            12.heightBox,
            MarketOverviewCard(),
            12.heightBox,
            TopIPOsSection(),
            12.heightBox,
            TopTradesSection(),
          ],
        ),
      ),
    );
  }
}
