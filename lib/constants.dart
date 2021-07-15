const String _imdbApi_ApiKey = '/k_80352qs8';
const String _imdbApi_baseUrl = 'https://imdb-api.com/en/API';

const String _mostPopularMovies_Query = '/MostPopularMovies';
const String mostPopularMovies_Endpoint =
    _imdbApi_baseUrl + _mostPopularMovies_Query + _imdbApi_ApiKey;

const String _trailer_Query = '/Trailer';
const String trailer_Endpoint =
    _imdbApi_baseUrl + _trailer_Query + _imdbApi_ApiKey;
