// lib/services/food_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shop_app/src/objects/food_class.dart';

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
  Future<List<Food>> getAllFoodsInCart() async {
    try {
      final response = await _dio.get('/incart');
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

  // Получить продукт в корзине по ID
  Future<List<Food>> getInCartById(int id) async {
    try {
      final response = await _dio.get('/incart/$id');
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

  Future<Food> addFoodToCart(Food food) async {
    try {
      final response = await _dio.put('/incart/${food.id}/add', data: food.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Food.fromJson(response.data);
      } else {
        throw Exception('Failed to add product. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Remove a product from the cart
  Future<void> deleteFoodFromCart(int id) async {
    try {
      final response = await _dio.put('/incart/$id/delete');
      if (response.statusCode != 200) {
        throw Exception('Failed to remove product. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Увеличить inCart
  Future<Food> incrementInCart(int id) async {
    try {
      final response = await _dio.put('/incart/$id/increment');
      if (response.statusCode == 200) {
        return Food.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception('Продукт не найден');
      } else {
        throw Exception('Не удалось обновить корзину. Статус: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Уменьшить inCart
  Future<Food> decrementInCart(int id) async {
    try {
      final response = await _dio.put('/incart/$id/decrement');
      if (response.statusCode == 200) {
        return Food.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw Exception('Продукт не найден');
      } else {
        throw Exception('Не удалось обновить корзину. Статус: ${response.statusCode}');
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
