import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/service/food_service.dart';
import 'package:flutter/material.dart';

class ShoppingCart with ChangeNotifier {
  final FoodService _cartService;

  List<CartItem> _items = [];

  List<CartItem> get items => _items;

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

  // Получить количество товара в корзине по его ID
  int getItemQuantity(int foodId) {
    try {
      return _items.firstWhere((item) => item.food.id == foodId).quantity;
    } catch (e) {
      return 0;
    }
  }

  // Проверить, находится ли товар в корзине
  bool isInCart(Food food) {
    return _items.any((item) => item.food.id == food.id);
  }

  // Добавить товар или увеличить его количество
  Future<void> addItem(Food food) async {
    try {
      final cartItem = await _cartService.addOrIncrementFoodInCart(food.id!);
      final index =
          _items.indexWhere((item) => item.food.id == cartItem.food.id);
      if (index >= 0) {
        _items[index] = cartItem;
      } else {
        _items.add(cartItem);
      }
      notifyListeners();
    } catch (e) {
      print('Ошибка добавления товара: $e');
      rethrow;
    }
  }

  // Уменьшить количество товара или удалить его из корзины
  Future<void> decrementItem(Food food) async {
    try {
      final updatedCartItem =
          await _cartService.removeOrDecrementFoodInCart(food.id!);
      if (updatedCartItem != null) {
        final index = _items
            .indexWhere((item) => item.food.id == updatedCartItem.food.id);
        if (index >= 0) {
          _items[index] = updatedCartItem;
        }
      } else {
        // Если обновленный элемент равен null, удаляем товар из локального списка
        _items.removeWhere((item) => item.food.id == food.id);
      }
      notifyListeners();
    } catch (e) {
      print('Ошибка уменьшения количества товара: $e');
      rethrow;
    }
  }

  // Полностью удалить товар из корзины
  Future<void> removeItem(Food food) async {
    try {
      await _cartService.removeFoodFromCart(food.id!);
      _items.removeWhere((item) => item.food.id == food.id);
      notifyListeners();
    } catch (e) {
      print('Ошибка удаления товара: $e');
      rethrow;
    }
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.food.price * item.quantity);
  }

  // Увеличить количество товара (аналогично addItem)
  Future<void> incrementItem(Food food) async {
    await addItem(food);
  }
}
