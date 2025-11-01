import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/recipe_model.dart';

class RecipeRepository {
  RecipeRepository();
  Future<List<Recipe>> getAll() async {
    final base = _baseRecipes();

    final need = base.length;

    final urls = <String>[];
    urls.addAll(await _fetchMealDbImages(need));
    if (urls.length < need) {
      urls.addAll(await _fetchFoodishImages(need - urls.length));
    }

    final seen = <String>{};
    final unique = <String>[];
    for (final u in urls) {
      if (u.isNotEmpty && seen.add(u)) unique.add(u);
      if (unique.length == need) break;
    }

    while (unique.length < need) {
      unique.add('assets/images/placeholder.jpg');
    }

    // Собираем готовые рецепты
    final List<Recipe> result = [];
    for (var i = 0; i < base.length; i++) {
      final b = base[i];
      result.add(Recipe(
        id: b.id,
        title: b.title,
        description: b.description,
        ingredients: b.ingredients,
        steps: b.steps,
        imageUrl: unique[i],
        cookTimeMinutes: b.cookTimeMinutes,
      ));
    }
    return result;
  }

  Future<Recipe> getById(String id) async {
    final b = _baseRecipes().firstWhere((r) => r.id == id);
    String image = await _getOneImage() ?? 'assets/images/placeholder.jpg';
    return Recipe(
      id: b.id,
      title: b.title,
      description: b.description,
      ingredients: b.ingredients,
      steps: b.steps,
      imageUrl: image,
      cookTimeMinutes: b.cookTimeMinutes,
    );
  }


  Future<List<String>> _fetchMealDbImages(int needed) async {
    final result = <String>[];
    final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
    for (final ch in letters) {
      if (result.length >= needed) break;
      final uri = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=$ch');
      try {
        final resp = await http.get(uri);
        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final meals = (data['meals'] as List?) ?? [];
          for (final m in meals) {
            if (result.length >= needed) break;
            final thumb = (m['strMealThumb'] as String?)?.trim();
            if (thumb != null && thumb.isNotEmpty) {
              result.add(thumb);
            }
          }
        }
      } catch (_) {
      }
    }
    return result;
  }

  Future<List<String>> _fetchFoodishImages(int needed) async {
    final result = <String>[];
    for (int i = 0; i < needed; i++) {
      try {
        final resp = await http.get(Uri.parse('https://foodish-api.com/api/'));
        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final url = (data['image'] as String?)?.trim();
          if (url != null && url.isNotEmpty) {
            result.add(url);
          }
        }
      } catch (_) {

      }
    }

    final seen = <String>{};
    result.retainWhere((u) => seen.add(u));
    return result;
  }

  Future<String?> _getOneImage() async {

    final meal = await _fetchMealDbImages(1);
    if (meal.isNotEmpty) return meal.first;

    final foodish = await _fetchFoodishImages(1);
    if (foodish.isNotEmpty) return foodish.first;
    return null;
  }


  List<_BaseRecipe> _baseRecipes() => const [
    _BaseRecipe(
      id: '101',
      title: 'Шакшука на завтрак',
      description: 'Яйца в ароматном томатном соусе с паприкой и зирой.',
      ingredients: [
        'Яйца — 3 шт',
        'Томаты — 400 г',
        'Лук — 1 шт',
        'Паприка — 1 ч.л.',
        'Зира — 0.5 ч.л.',
        'Чеснок — 2 зубчика',
        'Петрушка — по вкусу',
      ],
      steps: [
        'Обжарьте лук и чеснок на оливковом масле.',
        'Добавьте томаты, паприку и зиру, тушите 10 минут.',
        'Сделайте лунки и аккуратно вбейте яйца.',
        'Готовьте под крышкой до нужной консистенции.',
      ],
      cookTimeMinutes: 20,
    ),
    _BaseRecipe(
      id: '102',
      title: 'Боул с киноа и овощами',
      description: 'Лёгкий веган-боул с тахини-дрессингом.',
      ingredients: [
        'Киноа — 120 г',
        'Авокадо — 1 шт',
        'Огурец — 1 шт',
        'Морковь — 1 шт',
        'Нут — 100 г',
        'Соус тахини — 2 ст.л.',
        'Лимонный сок — 1 ст.л.',
      ],
      steps: [
        'Отварите киноа до готовности.',
        'Подготовьте овощи, нарежьте ломтиками.',
        'Соберите боул: киноа, овощи, нут, авокадо.',
        'Полейте соусом из тахини и лимона.',
      ],
      cookTimeMinutes: 25,
    ),
    _BaseRecipe(
      id: '103',
      title: 'Лосось терияки',
      description: 'Рыба в глазури терияки с рисом и брокколи.',
      ingredients: [
        'Филе лосося — 300 г',
        'Соус терияки — 2 ст.л.',
        'Рис — 100 г',
        'Брокколи — 100 г',
        'Кунжут — по вкусу',
      ],
      steps: [
        'Обжарьте лосося до румяной корочки.',
        'Добавьте соус терияки и карамелизуйте.',
        'Отварите рис и брокколи.',
        'Подавайте вместе, посыпав кунжутом.',
      ],
      cookTimeMinutes: 18,
    ),
    _BaseRecipe(
      id: '104',
      title: 'Рамен с курицей',
      description: 'Сытный бульон, лапша рамен и маринованное яйцо.',
      ingredients: [
        'Куриный бульон — 700 мл',
        'Лапша рамен — 100 г',
        'Курица — 150 г',
        'Соевый соус — 2 ст.л.',
        'Имбирь — 1 ч.л.',
        'Яйцо — 1 шт',
      ],
      steps: [
        'Соберите бульон с соевым соусом и имбирём.',
        'Отварите лапшу рамен.',
        'Добавьте курицу и яйцо.',
        'Подавайте горячим с зеленью.',
      ],
      cookTimeMinutes: 35,
    ),
    _BaseRecipe(
      id: '105',
      title: 'Салат с клубникой и шпинатом',
      description: 'Сладко-свежий салат с бальзамическим соусом.',
      ingredients: [
        'Шпинат — 100 г',
        'Клубника — 100 г',
        'Фета — 50 г',
        'Орехи — 20 г',
        'Бальзамик — 1 ст.л.',
        'Оливковое масло — 1 ст.л.',
      ],
      steps: [
        'Промойте и обсушите шпинат.',
        'Нарежьте клубнику и фету.',
        'Смешайте все ингредиенты.',
        'Заправьте бальзамиком и оливковым маслом.',
      ],
      cookTimeMinutes: 10,
    ),
    _BaseRecipe(
      id: '106',
      title: 'Чизкейк без выпечки',
      description: 'Нежный десерт на основе печенья и сливочного сыра.',
      ingredients: [
        'Печенье — 200 г',
        'Сливочное масло — 100 г',
        'Сливочный сыр — 200 г',
        'Сливки — 100 мл',
        'Сахар — 80 г',
        'Ягоды для украшения — по вкусу',
      ],
      steps: [
        'Измельчите печенье и смешайте с растопленным маслом.',
        'Выложите основу и охладите 30 минут.',
        'Взбейте сыр, сливки и сахар.',
        'Выложите крем и уберите в холодильник на 4 часа.',
        'Украсьте ягодами перед подачей.',
      ],
      cookTimeMinutes: 40,
    ),
  ];
}

class _BaseRecipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final int cookTimeMinutes;

  const _BaseRecipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.cookTimeMinutes,
  });
}
