class Quote {
  String quote;
  String author;

  Quote({
    required this.author,
    required this.quote,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'],
      author: json['author'],
    );
  }
}
