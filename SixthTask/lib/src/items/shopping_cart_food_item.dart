import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'dart:io';

class ShoppingCartFoodItem extends StatelessWidget {
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
    return ListTile(
      leading: _buildImage(food.img),
      title: Text(food.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
      subtitle: Text('${(food.inCart * food.salePrice * 100).round() / 100} ₽'),
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
              onPressed: onDecrement,
            ),
            Text(
              food.inCart.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 20,
              ),
              onPressed: onIncrement,
            ),
          ],
        ),
      ),
    );
  }
}
