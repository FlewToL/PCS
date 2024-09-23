import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/objects/food_obj.dart';

import 'package:shop_app/src/items/food_item.dart';
import 'package:shop_app/src/objects/categories_class.dart';

class CategoryPage extends StatelessWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<Food> foods = getFoodsByCategory(category);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        category.title,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      )),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          return FoodItem(item: foods[index]);
        },
      ),
    );
  }

  List<Food> getFoodsByCategory(Category category) {
    if (category.article == 'food_1') {
      return vegetablesList;
    }
    if (category.article == 'food_2') {
      return bakeryList;
    }
    return [];
  }
}
