import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_app/src/service/food_service.dart';
import 'package:shop_app/src/objects/orders_class.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late Future<List<OrderItem>> _orderItems;

  @override
  void initState() {
    super.initState();
    _orderItems = FoodService().getOrderItems(widget.orderId);
  }

  Widget _buildImage(String imgPath) {
    if (imgPath.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          imgPath,
          height: 80,
          width: 80,
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const Icon(
              Icons.image_not_supported,
              size: 80,
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
            height: 80,
            width: 80,
            fit: BoxFit.contain,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(
                Icons.image_not_supported,
                size: 80,
                color: Colors.grey,
              );
            },
          ),
        );
      } else {
        return const Icon(
          Icons.image_not_supported,
          size: 80,
          color: Colors.grey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Детали заказа #${widget.orderId}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<OrderItem>>(
        future: _orderItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет товаров в заказе.'));
          }

          List<OrderItem> items = snapshot.data!;

          // Вычисляем общую сумму
          double totalPrice = 0;
          for (var item in items) {
            totalPrice += item.productPrice * item.quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    OrderItem item = items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildImage(item.productImage.toString()),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Цена: ${item.productPrice} ₽',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${item.quantity} шт.',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Итого:',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222222)),
                    ),
                    Text(
                      '${totalPrice.toStringAsFixed(2)} ₽',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
