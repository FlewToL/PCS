import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/service/food_service.dart';
import 'package:flutter/material.dart';

class ShoppingCart with ChangeNotifier {
  final FoodService _cartService;

  List<Food> _items = [];

  List<Food> get items => [..._items];

  ShoppingCart({FoodService? apiService})
      : _cartService = apiService ?? FoodService();

  Future<void> initializeCart() async {
    try {
      _items = await _cartService.getAllFoodsInCart();
      notifyListeners();
    } catch (e) {
      print('Error initializing cart: $e');
    }
  }

  // Add an item to the cart
  Future<void> addItem(Food food) async {
    try {
      final addedFood = await _cartService.addFoodToCart(food);
      final index = _items.indexWhere((item) => item.id == addedFood.id);
      if (index >= 0) {
        _items[index].inCart = addedFood.inCart;
      } else {
        _items.add(addedFood);
      }
      notifyListeners();
    } catch (e) {
      // Handle or propagate the error
      print('Error adding item: $e');
      rethrow;
    }
  }

  // Remove an item from the cart
  Future<void> removeItem(Food food) async {
    try {
      await _cartService.deleteFoodFromCart(food.id!);
      _items.removeWhere((item) => item.id == food.id);
      notifyListeners();
    } catch (e) {
      print('Error removing item: $e');
      rethrow;
    }
  }

  Future<void> incrementItem(Food food) async {
    try {
      final updatedFood = await _cartService.incrementInCart(food.id!);
      final index = _items.indexWhere((item) => item.id == updatedFood.id);
      if (index >= 0) {
        _items[index].inCart = updatedFood.inCart;
        notifyListeners();
      }
    } catch (e) {
      print('Error incrementing item: $e');
      rethrow;
    }
  }

  Future<void> decrementItem(Food food) async {
    try {
      final updatedFood = await _cartService.decrementInCart(food.id!);
      final index = _items.indexWhere((item) => item.id == updatedFood.id);
      if (index >= 0) {
        if (updatedFood.inCart <= 0) {
          _items.removeAt(index);
        } else {
          _items[index].inCart = updatedFood.inCart;
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error decrementing item: $e');
      rethrow;
    }
  }

  bool isInCart(Food food) {
    return _items.any((item) => item.id == food.id);
  }

  int getItemQuantity(int foodId) {
    try {
      return _items.firstWhere((item) => item.id == foodId).inCart;
    } catch (e) {
      return 0;
    }
  }
}
