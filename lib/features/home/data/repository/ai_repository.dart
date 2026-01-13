import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:http/http.dart' as http;
import '../../../algorithm_engine/data/models/ipo_model.dart';
// final String openAIApiKey = dotenv.env['OPENAI_API'] ?? '';
// class OpenAIRepository {
//   Future<IpoAIAnalysis> analyzeIpoGmp({
//     required String ipoName,
//     required String newsText,
//   }) async {
//     final url = Uri.parse('https://api.openai.com/v1/chat/completions');

//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Bearer $openAIApiKey',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         "model": "gpt-4.1-mini",
//         "temperature": 0.2,
//         "messages": [
//           {
//             "role": "system",
//             "content":
//                 "You are a financial analyst. Respond only in strict JSON.",
//           },
//           {
//             "role": "user",
//             "content":
//                 """
// IPO: $ipoName

// Based on the following news text, extract:
// 1. Grey Market Premium (GMP) if mentioned
// 2. Overall sentiment (Positive / Neutral / Negative)
// 3. Confidence level (High / Medium / Low)

// News:
// $newsText

// Return JSON ONLY in this format:
// {
//   "gmp": "+₹120",
//   "sentiment": "Positive",
//   "confidence": "High"
// }
// """,
//           },
//         ],
//       }),
//     );

//     final json = jsonDecode(response.body);
//     final content = json['choices'][0]['message']['content'];

//     return IpoAIAnalysis.fromJson(jsonDecode(content));
//   }
// }

final String geminiApiKey = dotenv.env['GEMINI_API'] ?? '';

class GeminiRepository {
  final GenerativeModel _model;

  GeminiRepository()
    : _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: geminiApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.2,
          responseMimeType: 'application/json',
        ),
      );

  Future<IpoAIAnalysis> analyzeIpoGmp({
    required String ipoName,
    required String newsText,
  }) async {
    final response = await _model.generateContent([
      Content.text(_buildPrompt(ipoName, newsText)),
    ]);

    final raw = response.text ?? '';

    // 🔥 CLEANUP STEP
    final cleaned = raw.replaceAll('```json', '').replaceAll('```', '').trim();

    if (cleaned.isEmpty) {
      throw Exception('Empty Gemini response');
    }

    final decoded = jsonDecode(cleaned) as Map<String, dynamic>;

    return IpoAIAnalysis.fromJson(decoded);
  }

  String _buildPrompt(String ipoName, String newsText) =>
      '''
You are a financial data extractor.

ONLY respond with valid minified JSON.
NO markdown.
NO explanations.
NO extra text.

If multiple GMP values exist, return the MOST RECENT one.
If GMP is not explicitly stated, predict it by your own internet search and return in same format:

JSON schema:
{"gmp":"string","sentiment":"Positive|Neutral|Negative","confidence":"High|Medium|Low"}

e.g.
   {
     "gmp": "+₹11.5",
     "sentiment": "Positive",
     "confidence": "High"
   }

IPO: $ipoName

News:
$newsText
''';
}
