import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/items/favorite_food_item.dart';
import 'package:shop_app/src/objects/food_obj.dart';
import 'package:shop_app/src/items/food_item.dart';
import 'package:shop_app/src/objects/favorites_provider_class.dart';
import 'package:shop_app/src/pages/category_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Избранные товары',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favoriteList = favoritesProvider.favoriteList;

          if (favoriteList.isEmpty) {
            return const Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'В избранном пока пусто',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 340,
                  child: Text(
                    'Добавляйте любимые товары в избранное, чтобы не потерять.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                )
              ],
            ));
          }

          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: favoriteList.length,
            itemBuilder: (context, index) {
              final food = favoriteList[index];
              return FavoriteFoodItem(
                item: food,
                foodList: favoriteList,
              );
            },
          );
        },
      ),
    );
  }
}
