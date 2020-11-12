import 'dart:async';
import 'dart:convert';

import 'package:movies_app/src/models/actor_model.dart';
import 'package:movies_app/src/models/film_model.dart';
import 'package:http/http.dart' as http;

class FilmsProvider {
  String _apiKey = '89e93753bddb3dba78f6b5888714f7a1';
  String _urlBase = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularPage = 0;
  bool _loading = false;

  List<Film> _popular = new List();

  final _popularStreamController = StreamController<List<Film>>.broadcast();

  Function(List<Film>) get popularSink => _popularStreamController.sink.add;

  Stream<List<Film>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController?.close();
  }

  Future<List<Film>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final results = Films.fromJson(decodedData['results']);

    return results.films;
  }

  Future<List<Film>> getNowPlaying() async {
    final url = Uri.https(_urlBase, '3/movie/now_playing',
        {'api_key': _apiKey, 'languaje': _language});

    return await _processResponse(url);
  }

  Future<List<Film>> getPopular() async {
    if (_loading) {
      return [];
    }
    _loading = true;
    _popularPage++;

    final url = Uri.https(_urlBase, '3/movie/popular', {
      'api_key': _apiKey,
      'languaje': _language,
      'page': _popularPage.toString()
    });

    final resp = await _processResponse(url);

    _popular.addAll(resp);
    popularSink(_popular);

    _loading = false;

    return resp;
  }

  Future<List<Film>> getFilm(String query) async {
    final url = Uri.https(_urlBase, '3/search/movie', {
      'api_key': _apiKey,
      'languaje': _language,
      'query': query,
    });

    return await _processResponse(url);
  }

  Future<List<Actor>> getCast(String filmId) async {
    final url = Uri.https(_urlBase, '3/movie/$filmId/credits', {
      'api_key': _apiKey,
      'languaje': _language,
    });

    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final cast = Cast.fromJson(decodedData['cast']);

    return cast.actors;
  }
}
