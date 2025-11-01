import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:prac7/features/recipes/data/models/recipe_model.dart";

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: recipe.imageUrl,
                width: 80, height: 80, fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 80, height: 80, color: Colors.grey[200],
                  child: const Icon(Icons.restaurant_menu, color: Colors.grey),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 80, height: 80, color: Colors.red[100],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(recipe.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    recipe.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ]),
              ),
              Text(
                recipe.formattedTime,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF116A7B)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
