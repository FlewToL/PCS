// lib/services/food_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shop_app/src/objects/food_class.dart';

class CartItem {
  final Food food;
  final int quantity;

  CartItem({required this.food, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      food: Food.fromJson(json['good']),
      quantity: json['quantity'],
    );
  }
}

class FoodService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  final Dio _dio;

  FoodService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {'Content-Type': 'application/json'},
    responseType: ResponseType.json,
  ));

  // Получить все продукты
  Future<List<Food>> getAllFoods() async {
    try {
      final response = await _dio.get('/foods');
      if (response.statusCode == 200) {
        Iterable jsonResponse = response.data;
        return jsonResponse.map((food) => Food.fromJson(food)).toList();
      } else {
        throw Exception('Не удалось загрузить продукты. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Получить продукт по ID
  Future<Food> getFoodById(int id) async {
    try {
      final response = await _dio.get('/foods/$id');
      if (response.statusCode == 200) {
        return Food.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception('Продукт не найден');
      } else {
        throw Exception('Ошибка при загрузке продукта. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Добавить новый продукт
  Future<Food> addFood(Food food) async {
    try {
      final response = await _dio.post('/foods', data: food.toJson());
      if (response.statusCode == 201) {
        return Food.fromJson(response.data);
      } else {
        throw Exception('Не удалось добавить продукт. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Обновить продукт
  Future<Food> updateFood(Food food) async {
    if (food.id == null) {
      throw Exception('ID продукта не может быть null');
    }

    try {
      final response = await _dio.put('/foods/${food.id}', data: food.toJson());
      if (response.statusCode == 200) {
        return Food.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception('Продукт не найден');
      } else {
        throw Exception('Не удалось обновить продукт. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Удалить продукт
  Future<void> deleteFood(int id) async {
    try {
      final response = await _dio.delete('/foods/$id');
      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Продукт не найден');
      } else {
        throw Exception('Не удалось удалить продукт. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Получить все продукты в корзине
  Future<List<CartItem>> getAllFoodsInCart() async {
    try {
      final response = await _dio.get('/incart');
      if (response.statusCode == 200) {
        Iterable jsonResponse = response.data;
        return jsonResponse.map((item) => CartItem.fromJson(item)).toList();
      } else {
        throw Exception('Не удалось загрузить продукты. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Получить продукт в корзине по ID
  Future<CartItem?> getInCartById(int id) async {
    try {
      final response = await _dio.get('/incart/$id');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = response.data;
        return CartItem.fromJson(jsonResponse);
      } else {
        throw Exception('Не удалось загрузить продукт. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<CartItem> addOrIncrementFoodInCart(int goodId) async {
    try {
      final response = await _dio.post('/incart/$goodId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartItem.fromJson(response.data);
      } else {
        throw Exception('Не удалось добавить товар в корзину. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<CartItem?> removeOrDecrementFoodInCart(int goodId) async {
    try {
      final response = await _dio.put('/incart/$goodId');
      if (response.statusCode == 200) {
        return CartItem.fromJson(response.data);
      } else if (response.statusCode == 204) {
        return null;
      } else {
        throw Exception('Не удалось обновить товар в корзине. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<void> removeFoodFromCart(int goodId) async {
    try {
      final response = await _dio.delete('/incart/$goodId');
      if (response.statusCode != 204) {
        throw Exception('Не удалось удалить товар из корзины. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Получить все продукты в избранном
  Future<List<Food>> getAllFavorite() async {
    try {
      final response = await _dio.get('/favorite');
      if (response.statusCode == 200) {
        Iterable jsonResponse = response.data;
        return jsonResponse.map((food) => Food.fromJson(food)).toList();
      } else {
        throw Exception('Не удалось загрузить продукты. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Получить продукт в избранном по ID
  Future<Food> getFavoriteById(int id) async {
    try {
      final response = await _dio.get('/favorite/$id');
      if (response.statusCode == 200) {
        return Food.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception('Продукт не найден');
      } else {
        throw Exception('Ошибка при загрузке продукта. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Добавить новый продукт в избранное
  Future<Food> addFavorite(Food food) async {
    try {
      final response = await _dio.post('/favorite', data: food.toJson());
      if (response.statusCode == 201) {
        return Food.fromJson(response.data);
      } else {
        throw Exception('Не удалось добавить продукт. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Удалить продукт из избранного
  Future<void> deleteFavorite(int id) async {
    try {
      final response = await _dio.delete('/favorite/$id');
      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Продукт не найден');
      } else {
        throw Exception('Не удалось удалить продукт. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Обработка ошибок Dio
  void _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      throw Exception('Время подключения истекло');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      throw Exception('Время ожидания получения данных истекло');
    } else if (error.type == DioExceptionType.badResponse) {
      throw Exception('Получен неверный ответ от сервера: ${error.response?.statusCode}');
    } else if (error.type == DioExceptionType.cancel) {
      throw Exception('Запрос отменён');
    } else {
      throw Exception('Неизвестная ошибка: ${error.message}');
    }
  }
}
