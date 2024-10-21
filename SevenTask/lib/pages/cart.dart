// page_cart.dart
import 'package:flutter/material.dart';
import 'package:medicine_app/objects/goods_list.dart';
import 'package:medicine_app/items/incart.dart';
import 'package:medicine_app/objects/goods_class.dart';

class PageCart extends StatefulWidget {
  const PageCart({super.key});

  @override
  State<StatefulWidget> createState() => _StatePageCart();
}

class _StatePageCart extends State<PageCart> {
  late List<Goods> filteredGoodsList;

  @override
  void initState() {
    super.initState();
    filteredGoodsList = goodsList.where((goods) => goods.inCart > 0).toList();
  }

  void updateState() {
    setState(() {
      filteredGoodsList = goodsList.where((goods) => goods.inCart > 0).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: filteredGoodsList.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A6DE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Перейти к оформлению заказа',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
      ),
      body: filteredGoodsList.isEmpty
          ? _buildEmptyCart()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 26).copyWith(
          bottom: 100,
        ),
        itemCount: filteredGoodsList.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 90),
                Text(
                  'Корзина',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 30),
              ],
            );
          } else if (index == filteredGoodsList.length + 1) {
            return _buildTotal();
          } else {
            final goods = filteredGoodsList[index - 1];
            return CartItem(item: goods, onUpdate: () => updateState());
          }
        },
      ),
    );
  }

  Widget _buildTotal() {
    double total = filteredGoodsList.fold(
      0,
          (sum, item) => sum + (item.price * item.inCart),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Сумма',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            '${total.toStringAsFixed(0)} ₽',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26).copyWith(top: 90),
      child: const Column(
        children: [
          Text(
            'Корзина',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Color(0xFF1A6DE7),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Ваша корзина пуста',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Добавьте товары, чтобы начать',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



