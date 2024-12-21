import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/game_provider.dart';
import 'game_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh favorites when the screen is shown
    Provider.of<GameProvider>(context, listen: false).fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(47, 61, 81, 1),
        title: const Text(
          'Favorite Games',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.favoriteGames.isEmpty) {
            return const Center(child: Text('No favorite games yet.'));
          }
          return ListView.builder(
            itemCount: provider.favoriteGames.length,
            itemBuilder: (context, index) {
              final game = provider.favoriteGames[index];
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10), // Add vertical padding
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            game.backgroundImage,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                            width: 16), // Space between image and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game.name,
                                style: ts16BlackBold,
                              ),
                              const SizedBox(
                                  height:
                                      8), // Space between title and release date
                              Text('Released date ${game.released}'),
                              const SizedBox(
                                  height:
                                      8), // Space between release date and rating
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.orange),
                                  const SizedBox(width: 5),
                                  Text('${game.rating}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            provider.deleteFavorite(game.id);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
