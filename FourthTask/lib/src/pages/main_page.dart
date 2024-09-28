import 'package:flutter/material.dart';
import 'package:shop_app/src/items/category_item.dart';
import 'package:shop_app/src/objects/categories_obj.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_basket, color: Colors.black, size: 30),
              SizedBox(width: 8),
              Text(
                "Фуд-Маркет",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: categoryEntries.length,
        itemBuilder: (BuildContext ctx, int index) {
          return CategoryItem(category: categoryEntries[index]);
        },
      ),
    );
  }
}
