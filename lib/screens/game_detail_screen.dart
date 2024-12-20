import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/api_service.dart';

class GameDetailScreen extends StatefulWidget {
  final int gameId;

  const GameDetailScreen({super.key, required this.gameId});

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  final ApiService _apiService = ApiService();
  late Game game;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGameDetail();
  }

  void fetchGameDetail() async {
    game = await _apiService.fetchGameDetail(widget.gameId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(game.backgroundImage, fit: BoxFit.cover),
                  const SizedBox(height: 16),
                  Text(game.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Rating: ${game.rating}',
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
    );
  }
}
