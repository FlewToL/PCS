import 'package:flutter/material.dart';
import 'package:shop_app/src/objects/profile_class.dart';
import 'package:shop_app/src/pages/profile_settings_page.dart';
import 'package:shop_app/src/objects/profile_obj.dart';

import 'package:shop_app/src/pages/orders_page.dart';

class ProfileItem extends StatelessWidget {
  final Profile profItem;

  const ProfileItem({super.key, required this.profItem});

  void _handleTap(BuildContext context) {
    if (profItem.id == 6) {
      final profSettListItem = profileSettingsList[0];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSettingsPage(
            profSettItem: profSettListItem,
          ),
        ),
      );
    } else if (profItem.id == 1) {
      // При id == 0 открываем страницу заказов
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrdersPage(userId: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Нажат элемент с ID: ${profItem.id}'),
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
                profItem.icon,
                color: Colors.black,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              profItem.title,
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
