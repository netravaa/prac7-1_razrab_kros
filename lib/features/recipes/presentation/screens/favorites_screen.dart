import "package:flutter/material.dart";
import "../../data/repositories/recipe_repository.dart";
import "../../data/repositories/favorites_repository.dart";
import "../widgets/recipe_card.dart";
import "recipe_detail_screen.dart";
import "../../data/models/recipe_model.dart";

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesRepository _favRepo;

  @override
  void initState() {
    super.initState();
    _favRepo = FavoritesRepository(RecipeRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Избранное"),
        backgroundColor: const Color(0xFF116A7B),
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _favRepo.getFavorites(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snap.error}'));
          }
          final favs = snap.data ?? const <Recipe>[];
          if (favs.isEmpty) {
            return const Center(child: Text('Нет избранных рецептов'));
          }
          return ListView.builder(
            itemCount: favs.length,
            itemBuilder: (context, i) {
              final r = favs[i];
              return RecipeCard(
                recipe: r,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r))),
              );
            },
          );
        },
      ),
    );
  }
}
