import "package:flutter/material.dart";
import "../../data/repositories/recipe_repository.dart";
import "../../data/repositories/shopping_list_repository.dart";
import "../widgets/recipe_card.dart";
import "../../data/models/recipe_model.dart";

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});
  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  late final ShoppingListRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = ShoppingListRepository(RecipeRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Список покупок"),
        backgroundColor: const Color(0xFF116A7B),
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _repo.getSelectedRecipes(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snap.error}'));
          }
          final recipes = snap.data ?? const <Recipe>[];

          return Column(
            children: [
              Expanded(
                child: recipes.isEmpty
                    ? const Center(child: Text("Пока пусто"))
                    : ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context, i) => RecipeCard(recipe: recipes[i], onTap: () {}),
                      ),
              ),
              FutureBuilder<List<String>>(
                future: _repo.getCombinedIngredients(),
                builder: (context, ingSnap) {
                  if (ingSnap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  final ingredients = ingSnap.data ?? const <String>[];
                  if (ingredients.isEmpty) return const SizedBox.shrink();

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey[100], border: Border(top: BorderSide(color: Colors.grey[300]!))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("Ингредиенты:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...ingredients.map((e) => Text("• $e")),
                    ]),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
