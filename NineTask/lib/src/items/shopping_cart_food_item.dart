import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'dart:io';
import 'package:shop_app/src/service/food_service.dart';

class ShoppingCartFoodItem extends StatefulWidget {
  final Food food;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ShoppingCartFoodItem({
    super.key,
    required this.food,
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
          height: 70,
          width: 70,
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 70,
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
            height: 70,
            width: 70,
            fit: BoxFit.contain,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 70,
                color: Colors.grey,
              );
            },
          ),
        );
      } else {
        return const Icon(
          Icons.image_not_supported,
          size: 70,
          color: Colors.grey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.food.inCart);
    return ListTile(
      leading: _buildImage(widget.food.img),
      title: Text(
        widget.food.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      subtitle: Text('${(widget.food.inCart * widget.food.salePrice * 100).round() / 100} ₽'),
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
                widget.onDecrement();
                print(widget.food.inCart);
              },
            ),
            Text(
              widget.food.inCart.toString(),
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
