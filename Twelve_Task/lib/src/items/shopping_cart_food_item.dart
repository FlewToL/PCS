import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'dart:io';
import 'package:shop_app/src/service/food_service.dart';

import '../objects/shopping_cart_class.dart';

class ShoppingCartFoodItem extends StatefulWidget {
  final Food food;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ShoppingCartFoodItem({
    super.key,
    required this.food,
    required this.quantity,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  State<ShoppingCartFoodItem> createState() => _ShoppingCartFoodItemState();
}

class _ShoppingCartFoodItemState extends State<ShoppingCartFoodItem> {
  final FoodService _foodService = FoodService();
  late Future<List<Food>> _foodsFuture;

  @override
  void initState() {
    super.initState();
    _foodsFuture = _foodService.getAllFoods();
  }

  Widget _buildImage(String imgPath) {
    if (imgPath.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          imgPath,
          height: 80,
          width: 80,
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 80,
              color: Colors.grey,
            );
          },
        ),
      );
    } else {
      File imageFile = File(imgPath);
      if (imageFile.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.file(
            imageFile,
            height: 80,
            width: 80,
            fit: BoxFit.contain,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 80,
                color: Colors.grey,
              );
            },
          ),
        );
      } else {
        return const Icon(
          Icons.image_not_supported,
          size: 80,
          color: Colors.grey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shoppingCart = Provider.of<ShoppingCart>(context);
    bool isInCart = shoppingCart.isInCart(widget.food);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Добавляем отступы
      leading: _buildImage(widget.food.img),
      title: Text(
        widget.food.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
          '${(widget.quantity * widget.food.salePrice * 100).round() / 100} ₽',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      trailing: SizedBox(
        width: 120,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.remove,
                size: 20,
              ),
              onPressed: () {
                if (widget.quantity > 1) {
                  widget.onDecrement();
                } else {
                  widget.onRemove();
                }
              },
            ),
            Text(
              widget.quantity.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 20,
              ),
              onPressed: widget.onIncrement,
            ),
          ],
        ),
      ),
    );
  }
}
