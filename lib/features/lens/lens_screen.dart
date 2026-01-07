import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  File? _image;
  bool _loading = false;
  String _result = '';

  static const String geminiApiKey =
      String.fromEnvironment('GEMINI_API');

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
                      "Analyze this trading chart image. Identify trend (Bullish/Bearish/Sideways) and suggest Buy, Sell or Wait. Educational only."
                },
                {
                  "inlineData": {
                    "mimeType": "image/png",
                    "data": base64Image
                  }
                }
              ]
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);
      final text =
          data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Chart Lens AI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// HOW IT WORKS
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("How it works",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    StepItem("1", "Upload chart image"),
                    StepItem("2", "AI analyzes pattern"),
                    StepItem("3", "Get Buy / Sell / Wait"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// IMAGE
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _image!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            /// BUTTONS
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
                        backgroundColor: Colors.deepPurple),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_loading) const CircularProgressIndicator(),

            if (_result.isNotEmpty)
              Card(
                margin: const EdgeInsets.only(top: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("AI Result",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(
                        _result.replaceAll("**", ""),
                        style: const TextStyle(height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "⚠️ Educational purpose only",
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String step;
  final String text;
  const StepItem(this.step, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.deepPurple,
            child: Text(step,
                style:
                    const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
