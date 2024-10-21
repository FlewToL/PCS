import 'package:flutter/material.dart';
import 'package:medicine_app/objects/goods_list.dart';
import 'package:medicine_app/items/goods.dart';

class PageShop extends StatefulWidget {
  const PageShop({super.key});

  @override
  State<StatefulWidget> createState() => _StatePageShop();
}

class _StatePageShop extends State<PageShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        itemCount: goodsList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 90),
                Text(
                  'Каталог услуг',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 30),
              ],
            );
          } else {
            final goods = goodsList[index - 1];
            return GoodsItem(item: goods);
          }
        },
      ),
    );
  }
}
