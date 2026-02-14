class HoroscopeData {
  final String title;
  final String text;

  HoroscopeData({
    required this.title,
    required this.text,
  });

  factory HoroscopeData.fromJson(Map<String, dynamic> json) {
    return HoroscopeData(
      title: json['title'] ?? '',
      text: json['horoscope'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'horoscope': text,
  };
}
