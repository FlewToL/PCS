import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/service/food_service.dart';

class FavoritesProvider with ChangeNotifier {
  final FoodService _favoritesService;

  FavoritesProvider({FoodService? favoritesService})
      : _favoritesService = favoritesService ?? FoodService();

  final List<Food> _favoriteList = [];

  // Геттер для получения неизменяемого списка избранных
  List<Food> get favoriteList => List.unmodifiable(_favoriteList);

  /// Загрузка всех избранных продуктов из API
  Future<void> loadFavorites() async {
    try {
      final favorites = await _favoritesService.getAllFavorite();
      _favoriteList
        ..clear()
        ..addAll(favorites);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  /// Загрузка всех избранных продуктов из API по ID
  Future<void> loadFavoriteById(Food food) async {
    try {
      final favorites = await _favoritesService.getFavoriteById(food.id!);
      _favoriteList
        ..clear()
        ..add(favorites);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  /// Добавление продукта в избранное через API
  Future<void> addFavorite(Food food) async {
    try {
      final addedFood = await _favoritesService.addFavorite(food);
      _favoriteList.add(addedFood);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  /// Удаление продукта из избранного через API
  Future<void> removeFavorite(int id) async {
    try {
      await _favoritesService.deleteFavorite(id);
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
}
