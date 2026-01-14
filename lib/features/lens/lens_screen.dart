import 'dart:convert';
import 'dart:io';
import 'package:cupcake/core/export.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  File? _image;
  bool _loading = false;
  String _result = '';

  static const String geminiApiKey = String.fromEnvironment('GEMINI_API');

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      setState(() {
        _image = File(picked.path);
        _result = '';
      });
    } catch (e) {
      showError("Image picker failed");
    }
  }

  Future<void> analyzeChart() async {
    if (_image == null) return;

    setState(() => _loading = true);

    try {
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=$geminiApiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Analyze this trading chart image. Identify trend (Bullish/Bearish/Sideways) and suggest Buy, Sell or Wait. Educational only.",
                },
                {
                  "inlineData": {"mimeType": "image/png", "data": base64Image},
                },
              ],
            },
          ],
        }),
      );

      final data = jsonDecode(response.body);
      final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

      setState(() {
        _result = text ?? "No analysis received.";
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      showError("Analysis failed");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(title: const Text("Chart Lens AI"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.heightBox,
            Column(
              children: [
                Text(
                  'Upload chart image and get analysis',
                  style: AppTextTheme.accent14Bold,
                  // TextStyle(
                  //   color: AppColors.primaryPurple,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  textAlign: TextAlign.center,
                ),
                12.heightBox,
                Text(
                  'Find technical analysis in all your chart patterns',
                  style: AppTextTheme.size32Bold,
                  textAlign: TextAlign.center,
                ),
                16.heightBox,
                Text(
                  'A free and fast AI chart analyzer doing 12+ crucial checks to ensure that you get a perfect entry in all your trades.',
                  style: AppTextTheme.size14Normal,
                  textAlign: TextAlign.center,
                ),
                Lottie.asset(
                  'assets/resume_upload.json',
                  height: 300,
                  width: 300,
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                    _controller.repeat();
                  },
                  repeat: true,
                  frameRate: FrameRate.max,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Upload"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _image == null ? null : analyzeChart,
                        icon: const Icon(Icons.analytics),
                        label: const Text("Analyze"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ).px(12),
            24.heightBox,
            if (_loading) const CircularProgressIndicator(),

            if (_result.isNotEmpty)
              Card(
                margin: const EdgeInsets.only(top: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AI Result",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _result.replaceAll("**", ""),
                        style: const TextStyle(height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "⚠️ Educational purpose only",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            32.heightBox,
          ],
        ).pAll(16),
      ),
    );
  }
}
