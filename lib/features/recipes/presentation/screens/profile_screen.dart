import "package:flutter/material.dart";
import "package:prac7/features/recipes/presentation/screens/auth_screen.dart";
import "package:prac7/features/recipes/presentation/screens/favorites_screen.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
        backgroundColor: const Color(0xFF116A7B),
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Соколов Владимир"),
            accountEmail: Text("sokolov@mirea.ru"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF116A7B)),
            ),
            decoration: BoxDecoration(color: Color(0xFF116A7B)),
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF116A7B)),
            title: const Text("Мои заметки по рецептам"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Color(0xFF116A7B)),
            title: const Text("Избранное"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF116A7B)),
            title: const Text("Настройки"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Выйти", style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen())),
          ),
        ],
      ),
    );
  }
}
