import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Food> _favoriteList = [];

  List<Food> get favoriteList => List.unmodifiable(_favoriteList);

  void add(Food food) {
    _favoriteList.add(food);
    notifyListeners();
  }

  void remove(Food food) {
    _favoriteList.remove(food);
    notifyListeners();
  }

  bool isFavorite(Food food) {
    return _favoriteList.contains(food);
  }
}
