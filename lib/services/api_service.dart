import 'package:dio/dio.dart';
import '../models/game.dart';

class ApiService {
  final String apiKey = '46a2158602974cca833369ffefa1e5dc';
  final Dio dio = Dio();

  Future<List<Game>> fetchGames({int page = 1, int pageSize = 10}) async {
    final response = await dio.get(
      'https://api.rawg.io/api/games',
      queryParameters: {'key': apiKey, 'page': page, 'page_size': pageSize},
    );
    return (response.data['results'] as List)
        .map((json) => Game.fromJson(json))
        .toList();
  }

  Future<Game> fetchGameDetail(int id) async {
    final response = await dio.get('https://api.rawg.io/api/games/$id',
        queryParameters: {'key': apiKey});
    return Game.fromJson(response.data);
  }

  Future<List<Game>> searchGames(String query) async {
    final response =
        await dio.get('https://api.rawg.io/api/games', queryParameters: {
      'key': apiKey,
      'search': query,
    });
    return (response.data['results'] as List)
        .map((json) => Game.fromJson(json))
        .toList();
  }
}
