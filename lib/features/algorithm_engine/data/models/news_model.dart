// To parse this JSON data, do
//
//     final newsData = newsDataFromJson(jsonString);

import 'dart:convert';

List<NewsData> newsDataFromJson(String str) => List<NewsData>.from(json.decode(str).map((x) => NewsData.fromJson(x)));

String newsDataToJson(List<NewsData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsData {
    String title;
    String summary;
    String url;
    String imageUrl;
    DateTime pubDate;
    String source;
    List<String> topics;

    NewsData({
        required this.title,
        required this.summary,
        required this.url,
        required this.imageUrl,
        required this.pubDate,
        required this.source,
        required this.topics,
    });

    factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
        title: json["title"],
        summary: json["summary"],
        url: json["url"],
        imageUrl: json["image_url"],
        pubDate: DateTime.parse(json["pub_date"]),
        source: json["source"],
        topics: List<String>.from(json["topics"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "summary": summary,
        "url": url,
        "image_url": imageUrl,
        "pub_date": pubDate.toIso8601String(),
        "source": source,
        "topics": List<dynamic>.from(topics.map((x) => x)),
    };
}
