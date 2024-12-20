import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/api_service.dart';

class GameProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Game> games = [];
  bool isLoading = false;

  // Fetch game list
  Future<void> fetchGameList() async {
    isLoading = true;
    notifyListeners();
    games = await _apiService.fetchGames();
    isLoading = false;
    notifyListeners();
  }

  // Search games
  Future<void> searchGames(String query) async {
    isLoading = true;
    notifyListeners();
    games = await _apiService.searchGames(query);
    isLoading = false;
    notifyListeners();
  }
}
