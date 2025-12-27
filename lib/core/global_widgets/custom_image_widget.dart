// import 'dart:developer';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../config/colors/app_colors.dart';

// class CustomImageWidget extends StatelessWidget {
//   const CustomImageWidget({
//     super.key,
//     required this.mediaPath,
//     this.height,
//     this.width,
//     this.fit = BoxFit.cover,
//     this.borderRadius = 16,
//     this.color,
//     this.errorWidget,
//     this.loadingWidget,
//   });

//   final String mediaPath;
//   final double? height;
//   final double? width;
//   final BoxFit fit;
//   final double borderRadius;
//   final Color? color;
//   final Widget? errorWidget;
//   final Widget? loadingWidget;

//   bool get isVideo =>
//       mediaPath.toLowerCase().endsWith('.mp4') ||
//       mediaPath.toLowerCase().endsWith('.mov');

//   bool get isNetwork => mediaPath.startsWith('http');
//   bool get isAsset => mediaPath.startsWith('assets/');
//   bool get isFile => File(mediaPath).existsSync();

//   @override
//   Widget build(BuildContext context) {
//     if (mediaPath.isEmpty) return _buildErrorWidget();

//     // if (isVideo) {
//     //   return GestureDetector(
//     //     onTap: () {
//     //       showDialog(
//     //         context: context,
//     //         builder: (_) => VideoPopupScreen(videoPath: mediaPath),
//     //       );
//     //     },
//     //     child: Stack(
//     //       alignment: Alignment.center,
//     //       children: [
//     //         ClipRRect(
//     //           borderRadius: BorderRadius.circular(borderRadius),
//     //           child: Image.asset(
//     //             'assets/images/video_placeholder.jpg',
//     //             height: height,
//     //             width: width,
//     //             fit: fit,
//     //           ),
//     //         ),
//     //         const CircleAvatar(
//     //           radius: 24,
//     //           child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
//     //         ),
//     //       ],
//     //     ),
//     //   );
//     // }

//     if (isNetwork) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: CachedNetworkImage(
//           imageUrl: mediaPath,
//           height: height,
//           width: width,
//           fit: fit,
//           color: color,
//           errorWidget: (_, __, ___) => errorWidget ?? _buildErrorWidget(),
//           placeholder: (_, __) => loadingWidget ?? _buildLoadingWidget(),
//         ),
//       );
//     }

//     if (isAsset) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: Image.asset(
//           mediaPath,
//           height: height,
//           width: width,
//           fit: fit,
//           errorBuilder: (_, __, ___) => errorWidget ?? _buildErrorWidget(),
//         ),
//       );
//     }

//     if (isFile) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(borderRadius),
//         child: Image.file(
//           File(mediaPath),
//           height: height,
//           width: width,
//           fit: fit,
//           errorBuilder: (_, error, ___) {
//             log(error.toString());
//             return _buildErrorWidget();
//           },
//         ),
//       );
//     }

//     return _buildErrorWidget();
//   }

//   Widget _buildErrorWidget() => Container(
//     height: height,
//     width: width,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(borderRadius),
//       color: Colors.grey,
//     ),
//     child: const Icon(Icons.error_outline, color: AppColors.darkGreen),
//   );

//   Widget _buildLoadingWidget() => Shimmer.fromColors(
//     baseColor: Colors.grey,
//     highlightColor: Colors.white,
//     child: Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(borderRadius),
//       ),
//     ),
//   );
// }
