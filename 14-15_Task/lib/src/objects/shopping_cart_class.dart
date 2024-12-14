import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/service/food_service.dart';

import '../service/auth.dart';

class ShoppingCart with ChangeNotifier {
  final FoodService _cartService;
  final authService = AuthService();
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  ShoppingCart({FoodService? apiService})
      : _cartService = apiService ?? FoodService();

  /// Показать предупреждение о необходимости авторизации
  void _showAuthWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Пожалуйста, авторизуйтесь для выполнения этого действия.',
        style: TextStyle(fontSize: 18),),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> initializeCart(BuildContext context) async {
    try {
      String? userId = authService.getCurrentUserId();
      _items = await _cartService.getAllFoodsInCart(userId!);
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
  Future<void> addItem(BuildContext context, Food food) async {
    try {
      String? userId = authService.getCurrentUserId();
      if (userId == null) {
        _showAuthWarning(context);
        return;
      }
      final cartItem =
      await _cartService.addOrIncrementFoodInCart(food.id!, userId);
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
  Future<void> decrementItem(BuildContext context, Food food) async {
    try {
      String? userId = authService.getCurrentUserId();
      if (userId == null) {
        _showAuthWarning(context);
        return;
      }
      final updatedCartItem =
      await _cartService.removeOrDecrementFoodInCart(food.id!, userId);
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
  Future<void> removeItem(BuildContext context, Food food) async {
    try {
      String? userId = authService.getCurrentUserId();
      if (userId == null) {
        _showAuthWarning(context);
        return;
      }
      await _cartService.removeFoodFromCart(food.id!, userId);
      _items.removeWhere((item) => item.food.id == food.id);
      notifyListeners();
    } catch (e) {
      print('Ошибка удаления товара: $e');
      rethrow;
    }
  }

  void clearCart() async {
    _items.clear();
    notifyListeners(); // Уведомляем UI о необходимости обновления
  }

  void updateCartData() async {
    _items.clear();
    String? userId = authService.getCurrentUserId();
    _items = await _cartService.getAllFoodsInCart(userId!);
    notifyListeners();
    notifyListeners(); // Уведомляем UI о необходимости обновления
  }

  double get totalPrice {
    return _items.fold(
        0.0, (sum, item) => sum + item.food.price * item.quantity);
  }

  // Увеличить количество товара (аналогично addItem)
  Future<void> incrementItem(BuildContext context, Food food) async {
    await addItem(context, food);
  }
}
