import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';


class ShoppingCart with ChangeNotifier {
  final List<Food> _items = [];

  List<Food> get items => _items;

  void addItem(Food food) {
    // Проверяем, есть ли товар уже в корзине
    final index = _items.indexWhere((item) => item.title == food.title);
    if (index >= 0) {
      _items[index].incrementCount();
    } else {
      _items.add(food);
    }
    notifyListeners();
  }

  void removeItem(Food food) {
    final index = _items.indexWhere((item) => item.title == food.title);
    if (index >= 0) {
      _items[index].inCart = 0;
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void incrementItem(Food food) {
    final index = _items.indexWhere((item) => item.title == food.title);
    if (index >= 0) {
      _items[index].incrementCount();
      notifyListeners();
    }
  }

  void decrementItem(Food food) {
    final index = _items.indexWhere((item) => item.title == food.title);
    if (index >= 0) {
      _items[index].decrementCount();
      if (_items[index].inCart <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  bool isInCart(Food food) {
    return _items.any((item) => item.title == food.title);
  }
}

