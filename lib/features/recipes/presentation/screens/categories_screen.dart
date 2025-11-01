import 'package:flutter/material.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../data/models/recipe_model.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final RecipeRepository _repo = RecipeRepository();
  final PageController _controller = PageController();
  int _page = 0;

  final List<String> categories = ["Все","Завтрак","Веган","Рыба","Азиатская","Десерт"];

  List<Recipe> _filter(List<Recipe> all, String c) {
    if (c == "Все") return all;
    final q = c.toLowerCase();
    return all.where((r) => r.title.toLowerCase().contains(q) || r.description.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Категории"),
        backgroundColor: const Color(0xFF116A7B),
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
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
          final all = snap.data ?? const <Recipe>[];
          return Column(
            children: [
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: ChoiceChip(
                      label: Text(categories[i]),
                      selected: _page == i,
                      onSelected: (_) {
                        setState(() {
                          _page = i;
                          _controller.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  children: categories.map((c) {
                    final list = _filter(all, c);
                    if (list.isEmpty) {
                      return const Center(child: Text('Пусто в этой категории'));
                    }
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final r = list[i];
                        return RecipeCard(
                          recipe: r,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: r)),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
