import 'package:flutter/material.dart';
import 'package:shop_app/src/items/shopping_cart_food_item.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/objects/shopping_cart_class.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/service/food_service.dart';

class ShoppingCartPage extends StatelessWidget {
  final FoodService _orderService;

  const ShoppingCartPage({super.key, required FoodService orderService})
      : _orderService = orderService;

  Future<bool> _loadCartData(BuildContext context) async {
    final shoppingCart = Provider.of<ShoppingCart>(context, listen: false);
    await shoppingCart.initializeCart();
    return true;
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, Food food) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Удалить ${food.title}?'),
          content: const Text(
            'Вы действительно хотите удалить товар из корзины?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrder(BuildContext context) async {
    final shoppingCart = Provider.of<ShoppingCart>(context, listen: false);
    try {
      await _orderService.placeOrder(1); // Оформляем заказ на сервере
      shoppingCart.clearCart(); // Очищаем локальную корзину
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Заказ успешно оформлен!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при оформлении заказа: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadCartData(context), // Загружаем корзину
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final shoppingCart = Provider.of<ShoppingCart>(context);
        final cartItems = shoppingCart.items;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Корзина',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1.0,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: const TextStyle(color: Colors.black),
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.black,
          ),
          backgroundColor: Colors.white,
          body: cartItems.isEmpty
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_basket_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'В корзине пока пусто',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 340,
                  child: Text(
                    'Добавленные товары будут отображаться здесь',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                )
              ],
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: cartItems.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFFCCCCCC),
              thickness: 1,
              indent: 24,
              endIndent: 24,
            ),
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              final food = cartItem.food;
              final quantity = cartItem.quantity;

              return Slidable(
                key: Key(food.id.toString()), // Используем уникальный ID
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.15,
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        final shouldDelete =
                        await _showDeleteConfirmationDialog(context, food);

                        if (shouldDelete == true) {
                          shoppingCart.removeItem(food);
                          shoppingCart.initializeCart();
                        }
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Удалить',
                    ),
                  ],
                ),
                child: ShoppingCartFoodItem(
                  food: food,
                  quantity: quantity,
                  onRemove: () {
                    shoppingCart.removeItem(food);
                  },
                  onIncrement: () {
                    shoppingCart.incrementItem(food);
                  },
                  onDecrement: () {
                    shoppingCart.decrementItem(food);
                  },
                ),
              );
            },
          ),
          bottomNavigationBar: cartItems.isNotEmpty
              ? Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Итого: ${shoppingCart.totalPrice.toStringAsFixed(2)} ₽',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _placeOrder(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xFF60CA00),
                  ),
                  child: const Text(
                    'Оформить заказ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
              : null,
        );
      },
    );
  }
}

