class Trailer {
  final String title;
  final String year;
  final String videoDescription;
  final String linkEmbed;

  Trailer({
    required this.title,
    required this.year,
    required this.videoDescription,
    required this.linkEmbed,
  });

  factory Trailer.fromJson(Map<String, dynamic> parsedJson) {
    return Trailer(
      title: parsedJson['title'].toString(),
      year: parsedJson['year'].toString(),
      videoDescription: parsedJson['videoDescription'].toString(),
      linkEmbed: parsedJson['linkEmbed'].toString(),
    );
  }
}
