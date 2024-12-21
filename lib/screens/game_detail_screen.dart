import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../models/game.dart';
import '../services/db_service.dart';
import '../services/api_service.dart';

class GameDetailScreen extends StatefulWidget {
  final int gameId;

  const GameDetailScreen({super.key, required this.gameId});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  late Future<Game> _gameFuture;
  late Future<List<Game>> _favoriteGamesFuture;
  final ApiService _apiService = ApiService();
  final DBService _dbService = DBService();

  @override
  void initState() {
    super.initState();

    _gameFuture = _apiService.fetchGameDetail(widget.gameId);

    _favoriteGamesFuture = _dbService.getFavorites();
  }

  Future<void> _toggleFavorite(Game game) async {
    final favorites = await _favoriteGamesFuture;
    final isFavorite = favorites.any((favorite) => favorite.id == game.id);

    if (isFavorite) {
      await _dbService.deleteFavorite(game.id);
    } else {
      await _dbService.addFavorite(game);
    }

    setState(() {
      _favoriteGamesFuture = _dbService.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Detail',
          style: TextStyle(color: whiteColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FutureBuilder<List<Game>>(
            future: _favoriteGamesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return IconButton(
                  icon: const CircularProgressIndicator(),
                  onPressed: () {},
                );
              }

              if (snapshot.hasData) {
                final isFavorite = snapshot.data!
                    .any((favorite) => favorite.id == widget.gameId);

                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.white : Colors.white,
                  ),
                  onPressed: () async {
                    final game = await _gameFuture;
                    _toggleFavorite(game);
                  },
                );
              }

              return IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Game>(
        future: _gameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final game = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(game.backgroundImage),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: ts16BlackBold,
                      ),
                      sh10,
                      Text('Released date ${game.released}'),
                      sh10,
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange),
                          sw5,
                          Text('${game.rating}'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        game.descriptionRaw,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                      ),
                      Text(
                        'Game Description: ${game.name} is an amazing game with a rating of ${game.rating}.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
