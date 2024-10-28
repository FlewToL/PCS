import 'package:shop_app/src/objects/categories_class.dart';
import 'package:flutter/material.dart';

List<Category> categoryEntries = <Category>[
  Category(
      article: 'food_1',
      title: 'Овощи',
      img: 'assets/images/vegetables.png',
      colorCard: const Color(0xFFEBF3D4),
      colorText: const Color(0xFF3D4C1F),
  ),
  Category(
      article: 'food_2',
      title: 'Хлеб и выпечка',
      img: 'assets/images/bakery.png',
      colorCard: const Color(0xFFFFEEC8),
      colorText: const Color(0xFF473B0F),
  ),
  Category(
    article: 'food_3',
    title: 'Мясо и птица',
    img: 'assets/images/meat.png',
    colorCard: const Color(0xFFFDE6D9),
    colorText: const Color(0xFF3E2004),
  ),
  Category(
    article: 'food_4',
    title: 'Рыба',
    img: 'assets/images/fish.png',
    colorCard: const Color(0xFFDDE9FB),
    colorText: const Color(0xFF112E50),
  ),
];