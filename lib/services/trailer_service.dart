import 'package:http/http.dart' as http;
import 'package:movie/constants.dart';

class TrailerApiService {
  Future<http.Response> fetchTrailer(String movieId) async {
    final http.Response response = await http.get(
      Uri.parse(trailer_Endpoint + '/' + movieId),
    );
    return response;
  }
}
