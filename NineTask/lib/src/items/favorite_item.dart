import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/objects/food_obj.dart';
import 'package:shop_app/src/objects/favorites_provider_class.dart';
import 'package:provider/provider.dart';

double getEffectivePrice(double price, double salePrice) {
  if (salePrice < price) {
    return salePrice;
  } else {
    return price;
  }
}

String _getRemainingText(food) {
  if ((food.count <= 100) && (food.weight == 1000)) {
    return 'Осталось ${food.count} кг';
  } else if ((food.count <= 10) && (food.weight != 1000)) {
    return 'Осталось ${food.count} шт';
  } else {
    return 'В наличии много';
  }
}

Color _getTextColor(food) {
  if ((food.count <= 100) && (food.weight == 1000)) {
    return Colors.redAccent;
  } else if ((food.count <= 10) && (food.weight != 1000)) {
    return Colors.redAccent;
  } else {
    return Colors.black;
  }
}

class FavoriteItem extends StatefulWidget {
  final Food item;
  final VoidCallback onUpdate;

  const FavoriteItem({super.key, required this.item, required this.onUpdate});

  @override
  _FavoriteItemPageState createState() => _FavoriteItemPageState();
}

class _FavoriteItemPageState extends State<FavoriteItem> {
  bool get isFavorite => favoriteList.contains(widget.item);

  Widget _buildImage(String imgPath) {
    Widget imageWidget;

    if (imgPath.startsWith('assets/')) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          imgPath,
          height: 400,
          width: 400,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 400,
              color: Colors.grey,
            );
          },
        ),
      );
    } else {
      File imageFile = File(imgPath);
      if (imageFile.existsSync()) {
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.file(
            imageFile,
            height: 400,
            width: 400,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 400,
                color: Colors.grey,
              );
            },
          ),
        );
      } else {
        imageWidget = const Icon(
          Icons.image_not_supported,
          size: 400,
          color: Colors.grey,
        );
      }
    }

    return Center(
      child: imageWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    var food = widget.item;

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(food);

    void toggleFavorite() {
      if (isFavorite) {
        favoritesProvider.removeFavorite(widget.item.id!);
      } else {
        favoritesProvider.addFavorite(widget.item);
      }
      setState(() {});
    }

    Color countColor = _getTextColor(food);
    String countText = _getRemainingText(food);
    double effectivePrice = getEffectivePrice(food.price, food.salePrice);
    final screenWidth = MediaQuery.of(context).size.width * 0.9;
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final buttonWidth = screenWidth * 1;
    final buttonHeight = screenHeight * 0.07;
    bool isInCart = widget.item.inCart > 0;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(food.img),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          food.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  if (effectivePrice < food.price)
                                    TextSpan(
                                      text:
                                          "${effectivePrice.toStringAsFixed(2)} ₽",
                                      style: const TextStyle(
                                        color: Colors.lightGreen,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 34,
                                      ),
                                    ),
                                  if (effectivePrice < food.price)
                                    TextSpan(
                                      text:
                                          " ${food.price.toStringAsFixed(2)} ₽",
                                      style: const TextStyle(
                                        color: Color(0xFFBCBCBC),
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                      ),
                                    ),
                                  if (effectivePrice == food.price)
                                    TextSpan(
                                      text:
                                          "${food.price.toStringAsFixed(2)} ₽",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 34,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (food.weight == 1000)
                              Text(
                                "${(effectivePrice)} ₽/кг",
                                style: const TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontSize: 18,
                                ),
                              ),
                            if (food.weight != 1000)
                              Text(
                                "${(effectivePrice)} ₽/шт",
                                style: const TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontSize: 18,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          countText,
                          style: TextStyle(
                            color: countColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          '${food.desc}\n',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          'Условия хранения: ${food.expDate}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          'Производитель: ${food.brand}\n',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'Пищевая ценность на 100г:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          'Калории ${food.calories.toString()}\n'
                          'Жиры ${food.fat.toString()} г\n'
                          'Белки ${food.protein.toString()} г\n'
                          'Углеводы ${food.carbohydrate.toString()} г',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: isInCart
                        ? const Color(0xFF60CA00)
                        : const Color(0xFF60CA00),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: isInCart
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.item.decrementCount();
                                  widget.onUpdate();
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.item.inCart} шт.',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '${(widget.item.inCart * widget.item.salePrice * 100).round() / 100} ₽',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.item.incrementCount();
                                  widget.onUpdate();
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              widget.item.incrementCount();
                              widget.onUpdate();
                            });
                          },
                          borderRadius: BorderRadius.circular(20.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "В корзину",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18, // Размер текста
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            child: SizedBox(
              child: IconButton(
                onPressed: toggleFavorite,
                iconSize: 32,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? const Color(0xFFFF4444)
                      : const Color(0xFFD5D5D5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
