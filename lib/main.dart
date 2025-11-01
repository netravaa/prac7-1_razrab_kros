import "package:flutter/material.dart";
import "package:prac7/features/recipes/presentation/screens/auth_screen.dart";

void main() {
  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Каталог рецептов",
      theme: ThemeData(
        primaryColor: const Color(0xFF116A7B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF116A7B),
          foregroundColor: Colors.white,
        ),
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
