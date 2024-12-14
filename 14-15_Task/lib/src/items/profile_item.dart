import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/profile_class.dart';
import 'package:shop_app/src/pages/profile_settings_page.dart';
import 'package:shop_app/src/objects/profile_obj.dart';
import 'package:shop_app/src/service/food_service.dart';

import 'package:shop_app/src/pages/orders_page.dart';

import '../pages/chat_page.dart';
import '../pages/chat_support_page.dart';
import '../service/auth.dart';

class ProfileItem extends StatefulWidget {
  final Profile profItem;

  const ProfileItem({super.key, required this.profItem});

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  final authService = AuthService();
  final foodService = FoodService();

  void _handleTap(BuildContext context) async {
    if (widget.profItem.id == 6) {
      // Открыть настройки профиля
      final profSettListItem = profileSettingsList[0];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSettingsPage(
            profSettItem: profSettListItem,
          ),
        ),
      );
    } else if (widget.profItem.id == 1) {
      // Открыть список заказов
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrdersPage(),
        ),
      );
    } else if (widget.profItem.id == 8) {
      // Открыть диалог или список чатов в зависимости от роли
      try {
        String? userId = authService.getCurrentUserId();
        if (userId == null) {
          throw Exception('Ошибка: пользователь не найден.');
        }

        String role = await foodService.getUserRole(userId);

        if (role == 'user') {
          // Если роль "user", открыть диалог с техподдержкой
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                userId: userId,
                role: role, // Add the role variable here
              ),
            ),
          );
        } else if (role == 'admin') {
          // Если роль "admin", открыть список чатов пользователей
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminChatList(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Неизвестная роль: $role'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Остальные элементы
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Нажат элемент с ID: ${widget.profItem.id}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.125),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.profItem.icon,
                color: Colors.black,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              widget.profItem.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
