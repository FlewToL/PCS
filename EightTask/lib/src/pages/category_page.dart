import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/objects/food_obj.dart';
import 'package:shop_app/src/items/food_item.dart';
import 'package:shop_app/src/objects/categories_class.dart';
import 'package:shop_app/src/objects/favorites_provider_class.dart';
import 'package:shop_app/src/objects/shopping_cart_class.dart';

import 'add_food_page.dart';

import 'package:shop_app/src/service/food_service.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final FoodService _foodService = FoodService();
  late Future<List<Food>> _foodsFuture;

  @override
  void initState() {
    super.initState();
    _foodsFuture = _foodService.getAllFoods();
  }

  List<Food> getFoodsByCategory(List<Food> allFoods, Category category) {
    // Предположим, что категория хранится как 'brand' или другой атрибут
    // Настройте фильтр в соответствии с вашей логикой
    switch (category.article) {
      case 'food_1':
        return allFoods.where((food) => food.art == 'veg_food').toList();
      case 'food_2':
        return allFoods.where((food) => food.art == 'bak_food').toList();
      case 'food_3':
        return allFoods.where((food) => food.art == 'mea_food').toList();
      case 'food_4':
        return allFoods.where((food) => food.art == 'fis_food').toList();
      default:
        return [];
    }
  }

  Future<void> deleteFood(Food food) async {
    try {
      await _foodService.deleteFood(food.id!);
      setState(() {
        _foodsFuture = _foodService.getAllFoods();
      });

      final favoritesProvider =
          Provider.of<FavoritesProvider>(context, listen: false);
      favoritesProvider.removeFavorite(food.id!);
      final shoppingCart = Provider.of<ShoppingCart>(context, listen: false);
      shoppingCart.removeItem(food);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении продукта: $e')),
      );
    }
  }

  // Добавление продукта через API
  Future<void> addFood(Food food) async {
    try {
      await _foodService.addFood(food);
      setState(() {
        _foodsFuture = _foodService.getAllFoods();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении продукта: $e')),
      );
    }
  }

  void updateCallback() {
    setState(() {
      _foodsFuture = _foodService.getAllFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shoppingCart = Provider.of<ShoppingCart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            iconSize: 28,
            tooltip: 'Добавить товар',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFoodPage(
                    onAddFood: (food) {
                      addFood(food);
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Food>>(
        future: _foodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Пока данные загружаются
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // В случае ошибки
            return Center(
              child: Text(
                'Ошибка: ${snapshot.error}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Если нет данных
            return const Center(
              child: Text(
                'Здесь пока ничего нет =\'(',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            var allFoods = snapshot.data!;
            var foods = getFoodsByCategory(allFoods, widget.category);

            if (foods.isEmpty) {
              return const Center(
                child: Text(
                  'Ничего не найдено для этой категории.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: FoodItem(
                    item: foods[index],
                    onDelete: () => deleteFood(foods[index]),
                    onUpdate: () => updateCallback(),
                    onAdd: () {
                      shoppingCart.addItem(foods[index]);
                    },
                    onRemove: () {
                      shoppingCart.removeItem(foods[index]);
                    },
                    onIncrement: () {
                      shoppingCart.incrementItem(foods[index]);
                    },
                    onDecrement: () {
                      shoppingCart.decrementItem(foods[index]);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
