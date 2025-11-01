import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:prac7/features/recipes/data/models/recipe_model.dart";

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: const Color(0xFF116A7B),
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: recipe.imageUrl,
            width: double.infinity, height: 250, fit: BoxFit.cover,
            placeholder: (_, __) => Container(height: 250, color: Colors.grey[200], child: const Icon(Icons.menu_book, size: 50, color: Colors.grey)),
            errorWidget: (_, __, ___) => Container(height: 250, color: Colors.red[100], child: const Icon(Icons.error, size: 50, color: Colors.red)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(recipe.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(recipe.description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.timer, size: 18, color: Color(0xFF116A7B)),
                const SizedBox(width: 6),
                Text(recipe.formattedTime, style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 16),
              const Text("Ингредиенты", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...recipe.ingredients.map((i) => Row(
                children: [const Icon(Icons.check, size: 16, color: Colors.green), const SizedBox(width: 8), Expanded(child: Text(i))],
              )),
              const SizedBox(height: 16),
              const Text("Шаги", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...recipe.steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text("${e.key + 1}. ${e.value}"),
              )),
            ]),
          ),
        ],
      ),
    );
  }
}
