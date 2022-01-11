import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/models.dart';

class MovieProvider extends ChangeNotifier {

  final String _apiKey = '22c5dcdc1f43e458b2d959207955f463';
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiVersion = '/3';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularesPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionsStreamCtrl = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream => _suggestionsStreamCtrl.stream;

  MovieProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> getJsonData(String endPoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, '$_apiVersion/$endPoint', {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await getJsonData('movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularesPage++;
    final jsonData = await getJsonData('movie/popular', _popularesPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await getJsonData('movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '$_apiVersion/search/movie', {
      'api_key' : _apiKey,
      'language' : _language,
      'query' : query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchItem) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionsStreamCtrl.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchItem;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }

}
