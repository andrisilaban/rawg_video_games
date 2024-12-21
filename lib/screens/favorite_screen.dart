import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/game_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<GameProvider>(context, listen: false).fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Favorite Games',
          style: TextStyle(color: whiteColor),
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
                        horizontal: 20.0, vertical: 10),
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
                        sw15,
                        Expanded(
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
