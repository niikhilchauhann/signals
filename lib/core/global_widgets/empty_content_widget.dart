
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../export.dart';

class EmptyContentWidget extends StatelessWidget {
  final String image;
  final String title;
  final double padding;
  final bool isSVG;
  const EmptyContentWidget({
    super.key,
    required this.image,
    required this.title,
    this.padding = 16,
    this.isSVG = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        !isSVG
            ? Lottie.asset(
              'assets/lotties/$image.json',
              repeat: false,
              animate: true,
              frameRate: FrameRate.max,
            ).px(32)
            : SvgPicture.asset('assets/images/no_chat.svg'),
        // 16.heightBox,
        Center(
          child: Text(
            title,
            style: AppTextTheme.size14Normal.copyWith(
              color: AppColors.black.withValues(alpha: .5),
            ),
            textAlign: TextAlign.center,
          ),
        ).pOnly(top: padding),
      ],
    );
  }
}
