import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String _apiKey = dotenv.env['NEWAPI_API'] ?? '';
class NewsRepository {

  Future<String> fetchIpoNewsText(String ipoName) async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything'
      '?q=$ipoName IPO GMP grey market'
      '&language=en'
      '&sortBy=publishedAt'
      '&pageSize=5'
      '&apiKey=$_apiKey',
    );

    final response = await http.get(url);
    final json = jsonDecode(response.body);

    final articles = json['articles'] as List;

    return articles
        .map((a) => '${a['title']}. ${a['description']}')
        .join('\n');
  }
}
