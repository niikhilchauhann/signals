
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPopupScreen extends StatefulWidget {
//   final String videoPath;
//   const VideoPopupScreen({super.key, required this.videoPath});

//   @override
//   State<VideoPopupScreen> createState() => _VideoPopupScreenState();
// }

// class _VideoPopupScreenState extends State<VideoPopupScreen> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.videoPath.startsWith('http')
//         ? VideoPlayerController.networkUrl(Uri(path: widget.videoPath))
//         : VideoPlayerController.file(File(widget.videoPath));
//     _controller.initialize().then((_) {
//       setState(() {});
//       _controller.play();
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: _controller.value.isInitialized
//           ? AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             )
//           : SizedBox(
//               height: 200,
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//     );
//   }
// }
