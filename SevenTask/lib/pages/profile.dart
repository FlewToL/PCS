import 'package:flutter/material.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({super.key});

  @override
  State<StatefulWidget> createState() => _StatePageProfile();
}

class _StatePageProfile extends State<PageProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Эдуард',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat'
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                '+7 900 800-55-33',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                  color: Color(0xFF898A8D),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'email@gmail.com',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                  color: Color(0xFF898A8D),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 50),
              ListTile(
                leading: Image.asset('assets/icons/order.png'),
                title: const Text(
                  'Мои заказы',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Image.asset('assets/icons/cards.png'),
                title: const Text(
                  'Медицинские карты',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Image.asset('assets/icons/adress.png'),
                title: const Text(
                  'Мои адреса',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Image.asset('assets/icons/settings.png'),
                title: const Text(
                  'Настройки',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',),
                ),
                onTap: () {},
              ),
              const SizedBox(height: 160),
              Column(
                children: [
                  Text(
                    'Ответы на вопросы',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Политика конфиденциальности',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Пользовательское соглашение',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Add logout functionality
                      },
                      child: const Text(
                        'Выход',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFFD3535),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}