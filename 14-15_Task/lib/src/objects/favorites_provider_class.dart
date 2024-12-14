import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/service/food_service.dart';

import '../service/auth.dart';

class FavoritesProvider with ChangeNotifier {
  final FoodService _favoritesService;
  final authService = AuthService();

  FavoritesProvider({FoodService? favoritesService})
      : _favoritesService = favoritesService ?? FoodService() {
    // Автоматическая загрузка избранного при создании провайдера
    _initializeFavorites();
  }

  final List<Food> _favoriteList = [];

  // Геттер для получения неизменяемого списка избранных
  List<Food> get favoriteList => List.unmodifiable(_favoriteList);

  /// Показать предупреждение о необходимости авторизации
  void _showAuthWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Пожалуйста, авторизуйтесь для выполнения этого действия.'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Инициализация загрузки избранных продуктов при старте
  Future<void> _initializeFavorites() async {
    try {
      String? userId = authService.getCurrentUserId();
      if (userId == null) {
        print('Не авторизован: избранное не будет загружено.');
        return;
      }
      final favorites = await _favoritesService.getAllFavorite(userId);
      _favoriteList
        ..clear()
        ..addAll(favorites);
      notifyListeners();
    } catch (e) {
      print('Ошибка при загрузке избранных продуктов: $e');
    }
  }

  /// Загрузка всех избранных продуктов из API по ID
  Future<void> loadFavoriteById(BuildContext context, Food food) async {
    try {
      String? userId = authService.getCurrentUserId();
      if (userId == null) {
        _showAuthWarning(context);
        return;
      }
      final favorite = await _favoritesService.getFavoriteById(food.id!, userId);
      _favoriteList
        ..clear()
        ..add(favorite);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  /// Добавление продукта в избранное через API
  Future<void> addFavorite(BuildContext context, Food food) async {
    try {
      String? userId = authService.getCurrentUserId();
      if (userId == null) {
        _showAuthWarning(context);
        return;
      }
      final addedFood = await _favoritesService.addFavorite(food, userId);
      _favoriteList.add(addedFood);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  /// Удаление продукта из избранного через API
  Future<void> removeFavorite(BuildContext context, int id) async {
    try {
      String? userId = authService.getCurrentUserId();
      if (userId == null) {
        _showAuthWarning(context);
        return;
      }
      await _favoritesService.deleteFavorite(id, userId);
      _favoriteList.removeWhere((food) => food.id == id);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  /// Проверка, является ли продукт избранным
  bool isFavorite(Food food) {
    bool result = _favoriteList.any((item) => item.id == food.id);
    print('Проверка избранного для id ${food.id}: $result');
    return result;
  }

  void updateFavoritesData() async {
    _favoriteList.clear();
    String? userId = authService.getCurrentUserId();
    if (userId == null) {
      print('Не авторизован: избранное не будет загружено.');
      return;
    }
    final favorites = await _favoritesService.getAllFavorite(userId);
    _favoriteList
      ..clear()
      ..addAll(favorites);
    notifyListeners();
  }

  void clearFavorites() async {
    _favoriteList.clear();
    notifyListeners();
  }
}