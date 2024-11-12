import 'package:flutter/material.dart';
import 'package:shop_app/src/items/shopping_cart_food_item.dart';
import 'package:shop_app/src/objects/food_class.dart';
import 'package:shop_app/src/objects/shopping_cart_class.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

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


  @override
  Widget build(BuildContext context) {
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
        // Используйте elevation для теней
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
        ),
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
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
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
        separatorBuilder: (context, index) =>
        const Divider(
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
                    final shouldDelete = await _showDeleteConfirmationDialog(
                        context, food);

                    if (shouldDelete == true) {
                      shoppingCart.removeItem(food);
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Удалить', // Добавляем метку для лучшего UX
                ),
              ],
            ),
            child: ShoppingCartFoodItem(
              food: food,
              quantity: quantity,
              // Передаем количество
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
      // Добавим нижний раздел с общей стоимостью и кнопкой оформления заказа
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
              'Итого: \$${shoppingCart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Действие при нажатии на кнопку оформления заказа
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Оформить заказ'),
            ),
          ],
        ),
      )
          : null,
    );
  }
}
