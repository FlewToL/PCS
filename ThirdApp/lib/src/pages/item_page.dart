import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';

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
    return Colors.redAccent; // Цвет для условия if
  } else if ((food.count <= 10) && (food.weight != 1000)) {
    return Colors.redAccent; // Цвет для условий else и else if
  } else {
    return Colors.black; // Цвет для условий else и else if
  }
}

class ItemPage extends StatelessWidget {
  final Food food;

  const ItemPage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    Color countColor = _getTextColor(food);
    String countText = _getRemainingText(food);
    double effectivePrice = getEffectivePrice(food.price, food.salePrice);
    final screenWidth = MediaQuery.of(context).size.width * 0.9;
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final buttonWidth = screenWidth * 1;
    final buttonHeight = screenHeight * 0.07;

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
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    // Добавляем закругление
                    child: SizedBox.fromSize(
                      child: Image.asset(
                        food.img,
                        height: 340,
                        width: 340,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
                        offset: const Offset(0, 3), // Смещение тени
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
                            // Добавляем текст с ценой за вес
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
            bottom: 16.0, // Расстояние от нижнего края экрана
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF60CA00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart_rounded,
                          color: Colors.white, size: 30),
                      SizedBox(width: 8),
                      Text("В корзину",
                          style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
