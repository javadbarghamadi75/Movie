import 'package:http/http.dart' as http;
import 'package:movie/constants.dart';

class PopularMoviesApiService {
  Future<http.Response> fetchMovies() async {
    final http.Response response = await http.get(
      Uri.parse(mostPopularMovies_Endpoint),
    );
    return response;
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    // print('done');

    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    //   // final List<dynamic> results = jsonResponse['results'];
    //   // print('jsonResponse : ${jsonResponse}');
    //   // print('jsonResponse : ${jsonResponse['results']}');
    //   // print('jsonResponse : ${jsonResponse['results'][0]['original_title']}');
    //   final PopularMovies popularMoviesList =
    //       PopularMovies.fromJson(jsonResponse);
    //   final List<Result> results = popularMoviesList.results;
    //   // print('${popularMoviesList.results[0].backdropPath}');
    //   // print('responseResult : $results');
    // }
  }
}
