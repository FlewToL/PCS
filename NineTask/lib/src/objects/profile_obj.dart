import 'package:shop_app/src/objects/profile_class.dart';
import 'package:flutter/material.dart';

final List<Profile> profileList = [
  Profile(
    id: 1,
    icon: Icons.shopping_cart,
    title: 'Мои заказы',
  ),
  Profile(
    id: 2,
    icon: Icons.shopping_bag,
    title: 'Мои покупки',
  ),
  Profile(
    id: 3,
    icon: Icons.credit_card_rounded,
    title: 'Способы оплаты',
  ),
  Profile(
    id: 4,
    icon: Icons.local_offer,
    title: 'Промокоды',
  ),
  Profile(
    id: 5,
    icon: Icons.favorite,
    title: 'Избранное',
  ),
  Profile(
    id: 6,
    icon: Icons.settings,
    title: 'Настройки',
  ),
  Profile(
    id: 7,
    icon: Icons.help,
    title: 'ЧаВо',
  ),
  Profile(
    id: 8,
    icon: Icons.headset_mic_rounded,
    title: 'Служба поддержки',
  ),
  Profile(
    id: 9,
    icon: Icons.info,
    title: 'О приложении',
  ),
];

final List<ProfileSettings> profileSettingsList = [
  ProfileSettings(
      name: 'Роман',
      lastName: 'Акулов',
      phoneNumber: '+7 (123) 456-78-90',
      email: 'AkulovRoman@mail.ru',
      img: 'assets/images/anonim.jpg'
  )
];
