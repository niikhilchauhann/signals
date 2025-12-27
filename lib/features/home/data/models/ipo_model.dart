class Ipo {
  final String name;
  final String gmp;
  final String subscription;
  final String dates;
  final String type;

  Ipo({
    required this.name,
    required this.gmp,
    required this.subscription,
    required this.dates,
    required this.type,
  });

  Ipo copyWith({String? gmp}) {
    return Ipo(
      name: name,
      gmp: gmp ?? this.gmp,
      subscription: subscription,
      dates: dates,
      type: type
    );
  }

  factory Ipo.fromJson(Map<String, dynamic> json) {
    return Ipo(
      name: json['name'],
      gmp: json['gmp'],
      subscription: json['noOfTime'],
      dates: json['dates'],
      type: json['type'],

    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'gmp': gmp,
    'noOfTime': subscription,
    'dates': dates,
    'type': type
  };
}

class IpoAIAnalysis {
  final String gmp;
  final String sentiment;
  final String confidence;

  IpoAIAnalysis({
    required this.gmp,
    required this.sentiment,
    required this.confidence,
  });

  factory IpoAIAnalysis.fromJson(Map<String, dynamic> json) {
    return IpoAIAnalysis(
      gmp: json['gmp'] ?? 'Unknown',
      sentiment: json['sentiment'] ?? 'Neutral',
      confidence: json['confidence'] ?? 'Low',
    );
  }
}
