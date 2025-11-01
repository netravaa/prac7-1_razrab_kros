import "../models/recipe_model.dart";
import "recipe_repository.dart";

class ShoppingListRepository {
  final RecipeRepository _repo;
  final List<String> _selectedRecipeIds = ["102", "104"];

  ShoppingListRepository(this._repo);

  Future<List<Recipe>> getSelectedRecipes() async {
    final futures = _selectedRecipeIds.map((id) => _repo.getById(id));
    return Future.wait(futures);
  }

  Future<List<String>> getCombinedIngredients() async {
    final recipes = await getSelectedRecipes();
    final items = <String>[];
    for (final r in recipes) {
      items.addAll(r.ingredients);
    }
    return items.toSet().toList();
  }
}
