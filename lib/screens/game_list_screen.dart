import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameListScreen extends StatelessWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game List')),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading)
            return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: provider.games.length,
            itemBuilder: (context, index) {
              final game = provider.games[index];
              return ListTile(
                title: Text(game.name),
                subtitle: Text('Rating: ${game.rating}'),
                leading: Image.network(game.backgroundImage),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Provider.of<GameProvider>(context, listen: false).fetchGameList(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
