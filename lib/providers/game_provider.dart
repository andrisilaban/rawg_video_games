import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class GameProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DBService _dbService = DBService();

  List<Game> games = [];
  List<Game> favoriteGames = [];
  bool isLoading = false;

  GameProvider() {
    fetchGameList();
    fetchFavoriteGames();
  }

  Future<void> fetchGameList() async {
    isLoading = true;
    notifyListeners();
    games = await _apiService.fetchGames();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFavoriteGames() async {
    favoriteGames = await _dbService.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(Game game) async {
    await _dbService.addFavorite(game);
    await fetchFavoriteGames();
  }

  Future<void> deleteFavorite(int id) async {
    await _dbService.deleteFavorite(id);
    await fetchFavoriteGames();
  }

  bool isFavorite(int id) {
    return favoriteGames.any((game) => game.id == id);
  }

  void fetchFavorites() async {
    favoriteGames = await _dbService.getFavorites();
    notifyListeners();
  }
}
