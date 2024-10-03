import 'package:flutter/material.dart';
import 'package:shop_app/src/items/favorite_item.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/pages/item_page.dart';
import 'package:shop_app/src/pages/category_page.dart';

import 'dart:io';

// Функция для получения эффективной цены
double getEffectivePrice(double price, double salePrice) {
  return salePrice < price ? salePrice : price;
}

class FavoriteFoodItem extends StatefulWidget {
  final Food item;
  final List foodList;

  const FavoriteFoodItem({
    super.key,
    required this.item,
    required this.foodList,
  });

  @override
  State<FavoriteFoodItem> createState() => _FavoriteFoodItemState();
}

class _FavoriteFoodItemState extends State<FavoriteFoodItem> {
  Widget _buildImage(String imgPath) {
    if (imgPath.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          imgPath,
          height: 160,
          width: 160,
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 160,
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
            height: 160, // Совместимый размер с asset изображениями
            width: 160,
            fit: BoxFit.contain, // Изменено на BoxFit.contain
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 160,
                color: Colors.grey,
              );
            },
          ),
        );
      } else {
        return const Icon(
          Icons.image_not_supported,
          size: 160,
          color: Colors.grey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double effectivePrice =
        getEffectivePrice(widget.item.price, widget.item.salePrice);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoriteItem(
              item: widget.item,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildImage(widget.item.img),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 10,
                bottom: 8,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF60CA00),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    iconSize: 22,
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      children: [
                        if (effectivePrice < widget.item.price) ...[
                          TextSpan(
                            text: "${effectivePrice.toStringAsFixed(2)} ₽ ",
                            style: const TextStyle(
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: "${widget.item.price.toStringAsFixed(2)} ₽",
                            style: const TextStyle(
                              color: Color(0xFFBCBCBC),
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                        if (effectivePrice == widget.item.price)
                          TextSpan(
                            text: "${widget.item.price.toStringAsFixed(2)} ₽",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
