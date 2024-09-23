import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/pages/item_page.dart';

double getEffectivePrice(double price, double salePrice) {
  if (salePrice < price) {
    return salePrice;
  } else {
    return price;
  }
}

String _getRemainingText(item) {
  if ((item.count <= 100) && (item.weight == 1000)) {
    return 'Осталось ${item.count} кг';
  } else if ((item.count <= 10) && (item.weight != 1000)) {
    return 'Осталось ${item.count} шт';
  } else {
    return '';
  }
}

Color _getTextColor(item) {
  if ((item.count <= 100) && (item.weight == 1000)) {
    return Colors.redAccent; // Цвет для условия if
  } else if ((item.count <= 10) && (item.weight != 1000)) {
    return Colors.redAccent; // Цвет для условий else и else if
  } else {
    return Colors.black; // Цвет для условий else и else if
  }
}

class FoodItem extends StatelessWidget {
  final Food item;

  const FoodItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Color countColor = _getTextColor(item);
    String countText = _getRemainingText(item);
    double effectivePrice = getEffectivePrice(item.price, item.salePrice);
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ItemPage(food: item)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
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
          width: MediaQuery.sizeOf(context).width * 0.2,
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: SizedBox.fromSize(
                      child: Image.asset(
                        item.img,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16),
                          children: [
                            if (effectivePrice < item.price)
                              TextSpan(
                                text: "${effectivePrice.toStringAsFixed(2)} ₽",
                                style: const TextStyle(
                                    color: Colors.lightGreen,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 34),
                              ),
                            if (effectivePrice < item.price)
                              TextSpan(
                                text: " ${item.price.toStringAsFixed(2)} ₽",
                                style: const TextStyle(
                                    color: Color(0xFFBCBCBC),
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 16),
                              ),
                            if (effectivePrice == item.price)
                              TextSpan(
                                text: "${item.price.toStringAsFixed(2)} ₽",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 34,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        countText,
                        style: TextStyle(
                          color: countColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFF60CA00),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    iconSize: 36,
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
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
