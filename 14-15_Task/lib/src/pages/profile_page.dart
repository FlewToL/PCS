import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/objects/profile_obj.dart';
import 'package:shop_app/src/items/profile_item.dart';
import 'package:dio/dio.dart';
import 'package:shop_app/src/service/food_service.dart';

import '../objects/favorites_provider_class.dart';
import '../objects/shopping_cart_class.dart';
import '../service/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  final foodService = FoodService();
  String? userName; // Имя пользователя
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void logOut() async {
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    final shoppingCart = Provider.of<ShoppingCart>(context, listen: false);
    favoritesProvider.clearFavorites();
    shoppingCart.clearCart();
    await authService.signOut();
  }

  Future<void> _fetchUserName() async {
    try {
      userId =
          authService.getCurrentUserId(); // Получаем текущий ID пользователя
      if (userId == null) {
        setState(() {
          userName = "Гость"; // Если пользователь не авторизован
        });
        return;
      }
      final users = await foodService.fetchUsers();

      // Ищем пользователя по ID
      final user = users.firstWhere(
        (user) => user['id'] == userId,
        orElse: () => null,
      );

      if (user != null) {
        setState(() {
          userName = user['name']; // Устанавливаем имя пользователя
        });
      } else {
        setState(() {
          userName = "Неизвестный пользователь";
        });
      }
    } catch (e) {
      print('Ошибка при загрузке имени пользователя: $e');
      setState(() {
        userName = "Ошибка загрузки";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(onPressed: logOut, icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: profileList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                userName != null
                    ? 'Здравствуйте, $userName!' // Динамическое отображение имени
                    : '...',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else {
            final item = profileList[index - 1];
            return ProfileItem(profItem: item);
          }
        },
      ),
    );
  }
}
