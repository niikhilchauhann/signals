// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';

// class StorageRepository {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<String> uploadMedia(File file, String path) async {
//     try {
//       if (file.path.endsWith('.jpg') || file.path.endsWith('.png')) {
//         file = await compressImage(file);
//       }
//       //  else if (file.path.endsWith('.mov') ||
//       //     file.path.endsWith('.mp4') ||
//       //     file.path.endsWith('.mkv')) {
//       //   file = await compressVideo(file);
//       // }

//       final ref = _storage.ref().child(path);

//       await ref.putFile(file);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       debugPrint('Error uploading media: $e');
//       throw Exception('Failed to upload media');
//     }
//   }

//   Future<File> compressImage(File file) async {
//     final result = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path,
//       '${file.path}_compressed.jpg',
//       quality: 64, // Reduce quality to save space
//     );
//     return File(result!.path);
//   }

//   // Future<File> compressVideo(File file) async {
//   //   final MediaInfo? info = await VideoCompress.compressVideo(
//   //     file.path,
//   //     quality: VideoQuality.Res1280x720Quality, // Reduce quality slightly
//   //   );
//   //   return File(info!.path!);
//   // }

//   // Future<File> generateThumbnail(File file) async {
//   //   final info = await VideoCompress.getFileThumbnail(
//   //     file.path,
//   //     quality: 70, // Reduce quality slightly
//   //   );
//   //   return File(info.path);
//   // }

//   // Future<File> generatePreviewVideo(
//   //   File originalVideo, {
//   //   Duration duration = const Duration(seconds: 5),
//   // }) async {
//   //   final MediaInfo? trimmed = await VideoCompress.compressVideo(
//   //     originalVideo.path,
//   //     startTime: 0,
//   //     duration: duration.inSeconds,
//   //     includeAudio: true,
//   //   );

//   //   if (trimmed == null || trimmed.path == null) {
//   //     throw Exception("Failed to generate preview video");
//   //   }

//   //   return File(trimmed.path!);
//   // }

  
// }


// class ProfileImageCache {
//   static final Map<String, String> _cache = {};

//   static String? get(String uid) => _cache[uid];

//   static void set(String uid, String url) {
//     _cache[uid] = url;
//   }
// }
