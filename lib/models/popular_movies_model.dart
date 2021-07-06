class PopularMovies {
  final List<Item> items;

  PopularMovies({
    required this.items,
  });

  factory PopularMovies.fromJson(Map<String, dynamic> parsedList) {
    List<dynamic> popularMoviesList = parsedList['items'] as List;
    List<Item> items = popularMoviesList
        .map((aPopularMovieMap) => Item.fromJson(aPopularMovieMap))
        .toList();
    return PopularMovies(
      items: items,
    );
  }
}

class Item {
  final String id;
  final int rank;
  final String title;
  final String year;
  final String image;
  final String imDbRating;

  Item({
    required this.id,
    required this.rank,
    required this.title,
    required this.year,
    required this.image,
    required this.imDbRating,
  });

  factory Item.fromJson(Map<String, dynamic> parsedJson) {
    return Item(
      id: parsedJson['id'].toString(),
      rank: int.parse(parsedJson['rank']),
      title: parsedJson['title'].toString(),
      year: parsedJson['year'].toString(),
      image: parsedJson['image'].toString(),
      imDbRating: parsedJson['imDbRating'].toString(),
    );
  }
}
