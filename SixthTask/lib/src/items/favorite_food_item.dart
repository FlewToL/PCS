import 'package:flutter/material.dart';
import 'package:shop_app/src/items/favorite_item.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/objects/favorites_provider_class.dart';
import 'package:shop_app/src/objects/shopping_cart_class.dart';
import 'package:provider/provider.dart';

import 'dart:io';

// Функция для получения эффективной цены
double getEffectivePrice(double price, double salePrice) {
  return salePrice < price ? salePrice : price;
}

class FavoriteFoodItem extends StatefulWidget {
  final Food item;
  final List foodList;
  final VoidCallback onUpdate;

  const FavoriteFoodItem({
    super.key,
    required this.item,
    required this.foodList,
    required this.onUpdate
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

    final shoppingCart = Provider.of<ShoppingCart>(context);
    bool isInCart = shoppingCart.isInCart(widget.item);

    double screenWidth = MediaQuery.of(context).size.width;
    double maxContainerWidth = screenWidth - 24;
    double containerWidth = isInCart ? 200 : 48;
    containerWidth =
    containerWidth > maxContainerWidth ? maxContainerWidth : containerWidth;



    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(widget.item);

    void toggleFavorite() {
      if (isFavorite) {
        favoritesProvider.remove(widget.item);
      } else {
        favoritesProvider.add(widget.item);
      }
      setState(() {});
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoriteItem(
              item: widget.item,
              onUpdate: () => widget.onUpdate(),
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
                left: 9,
                bottom: 9,
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
              Positioned(
                  right: 12,
                  bottom: 12,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    width: containerWidth,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF60CA00),
                      borderRadius:
                      BorderRadius.circular(isInCart ? 12.0 : 23.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: isInCart
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              shoppingCart.decrementItem(widget.item);
                            });
                          },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${widget.item.inCart} шт.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${(widget.item.inCart * widget.item.salePrice*100).round()/100} ₽',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              shoppingCart.incrementItem(widget.item);
                            });
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: IconButton(
                        padding: const EdgeInsets.only(right: 0.0),
                        onPressed: () {
                          setState(() {
                            shoppingCart.addItem(widget.item);
                            shoppingCart.incrementItem(widget.item);
                          });
                        },
                        iconSize: 24,
                        icon: const Icon(Icons.shopping_cart),
                        color: Colors.white,
                      ),
                    ),
                  )
              ),
              Positioned(
                right: 0,
                top: 0,
                child: SizedBox(
                  child: IconButton(
                    onPressed: toggleFavorite,
                    iconSize: 26,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? const Color(0xFFFF4444) : const Color(0xFFD5D5D5),
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
