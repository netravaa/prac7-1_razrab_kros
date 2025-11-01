import "../models/recipe_model.dart";
import "recipe_repository.dart";

class FavoritesRepository {
  final RecipeRepository _repo;
  final List<String> _favIds = ["101", "106"];

  FavoritesRepository(this._repo);

  Future<List<Recipe>> getFavorites() async {
    final futures = _favIds.map((id) => _repo.getById(id));
    return Future.wait(futures);
  }
}
