import 'package:flutter/material.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../data/models/recipe_model.dart';
import '../widgets/recipe_card.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'recipe_detail_screen.dart';
import 'shopping_list_screen.dart';

class RecipesScreen extends StatelessWidget {
  RecipesScreen({super.key});

  final RecipeRepository _repo = RecipeRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Каталог рецептов"),
        backgroundColor: const Color(0xFF116A7B),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen())),
            tooltip: "Категории",
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
            tooltip: "Избранное",
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            tooltip: "Профиль",
          ),
        ],
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _repo.getAll(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snap.error}'));
          }
          final recipes = snap.data ?? const <Recipe>[];
          if (recipes.isEmpty) {
            return const Center(child: Text('Рецептов нет'));
          }
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, i) {
              final r = recipes[i];
              return RecipeCard(
                recipe: r,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShoppingListScreen())),
        backgroundColor: const Color(0xFF116A7B),
        child: const Icon(Icons.list, color: Colors.white),
      ),
    );
  }
}
