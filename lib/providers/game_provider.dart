import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/api_service.dart';

class GameProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Game> games = [];
  bool isLoading = false;

  GameProvider() {
    fetchGameList();
  }

  Future<void> fetchGameList() async {
    isLoading = true;
    notifyListeners();
    games = await _apiService.fetchGames();
    isLoading = false;
    notifyListeners();
  }
}
