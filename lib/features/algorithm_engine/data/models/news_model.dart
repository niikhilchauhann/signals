import 'dart:convert';

List<NewsArticle> newsArticleListFromJson(String str) =>
    List<NewsArticle>.from(
      json.decode(str).map((x) => NewsArticle.fromJson(x)),
    );

String newsArticleListToJson(List<NewsArticle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsArticle {
  final String title;
  final String summary;
  final String url;
  final String imageUrl;
  final DateTime pubDate;
  final String source;
  final List<String> topics;

  NewsArticle({
    required this.title,
    required this.summary,
    required this.url,
    required this.imageUrl,
    required this.pubDate,
    required this.source,
    required this.topics,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json["title"] ?? "",
      summary: json["summary"] ?? "",
      url: json["url"] ?? "",
      imageUrl: json["image_url"] ?? "",
      pubDate: DateTime.parse(json["pub_date"]),
      source: json["source"] ?? "",
      topics: json["topics"] == null
          ? []
          : List<String>.from(json["topics"].map((x) => x.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "summary": summary,
        "url": url,
        "image_url": imageUrl,
        "pub_date": pubDate.toIso8601String(),
        "source": source,
        "topics": List<dynamic>.from(topics),
      };
}
