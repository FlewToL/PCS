import 'package:flutter/material.dart';

void main() {
  runApp(const SecondApp());
}

const Color primaryAccentColor = Color(0xFFFFCC00);
const Color primaryAccent2Color = Color(0xFFFFFF00);
const Color primaryColor = Color(0xFF111111);

class SecondApp extends StatelessWidget {
  const SecondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryColor,
        body: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Авторизация',
              style: TextStyle(
                  color: primaryAccentColor,
                  fontSize: 34, 
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1f1f1f),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Логин',
                  labelStyle: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 18,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1f1f1f),
                  labelText: 'Пароль',
                  labelStyle: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 18,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                    checkColor: primaryAccentColor,
                    side: const BorderSide(color: primaryAccent2Color, width: 2),
                  ),
                  const Text(
                    'Запомнить меня',
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryAccent2Color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                width: 380,
                child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Войти',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                width: 380,
                child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    side: const BorderSide(color: primaryAccentColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Регистрация',
                    style: TextStyle(
                      color: primaryAccentColor,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Восстановить пароль',
                    style: TextStyle(
                      color: primaryAccent2Color,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
