import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie List')),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: provider.games.length,
            itemBuilder: (context, index) {
              final game = provider.games[index];
              return ListTile(
                leading: Image.network(game.backgroundImage,
                    width: 80, height: 80, fit: BoxFit.cover),
                title: Text(game.name),
                subtitle: Text('Rating: ${game.rating}'),
                onTap: () {
                  // Navigate to Game Detail Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailScreen(gameId: game.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<GameProvider>(context, listen: false).fetchGameList();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
