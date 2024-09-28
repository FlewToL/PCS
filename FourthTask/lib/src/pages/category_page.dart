import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/objects/food_obj.dart';

import 'package:shop_app/src/items/food_item.dart';
import 'package:shop_app/src/objects/categories_class.dart';

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
    return [];
  }

  void _deleteFood(Food food) {
    setState(() {
      if (widget.category.article == 'food_1') {
        vegetablesList.remove(food);
      } else if (widget.category.article == 'food_2') {
        bakeryList.remove(food);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Food> foods = getFoodsByCategory(widget.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return FoodItem(
                item: food,
                onDelete: () {
                  _deleteFood(food);
                },
              );
            },
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
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
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
                iconSize: 42,
                icon: const Icon(Icons.add),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
