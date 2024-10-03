import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/objects/food_obj.dart';
import 'package:shop_app/src/items/food_item.dart';
import 'package:shop_app/src/objects/categories_class.dart';
import 'package:shop_app/src/objects/favorites_provider_class.dart';
import 'add_food_page.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Food> getFoodsByCategory(Category category) {
    if (category.article == 'food_1') {
      return vegetablesList;
    }
    if (category.article == 'food_2') {
      return bakeryList;
    }
    if (category.article == 'food_3') {
      return meatList;
    }
    if (category.article == 'food_4') {
      return fishList;
    }
    return [];
  }

  void deleteFood(Food food) {
    setState(() {
      final favoritesProvider =
          Provider.of<FavoritesProvider>(context, listen: false);
      favoritesProvider.remove(food);
      if (widget.category.article == 'food_1') {
        vegetablesList.remove(food);
      } else if (widget.category.article == 'food_2') {
        bakeryList.remove(food);
      } else if (widget.category.article == 'food_3') {
        meatList.remove(food);
      } else if (widget.category.article == 'food_4') {
        fishList.remove(food);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var foods = getFoodsByCategory(widget.category);
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
                      setState(() {
                        if (widget.category.article == 'food_1') {
                          vegetablesList.add(food);
                        } else if (widget.category.article == 'food_2') {
                          bakeryList.add(food);
                        } else if (widget.category.article == 'food_3') {
                          meatList.add(food);
                        } else if (widget.category.article == 'food_4') {
                          fishList.add(food);
                        }
                      });
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
      body: Stack(
        children: [
          foods.isEmpty
              ? const Center(
                  child: Text(
                    'Здесь пока ничего нет =\'(',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: FoodItem(
                        item: foods[index],
                        foodList: foods,
                        onDelete: () => deleteFood(foods[index]),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
