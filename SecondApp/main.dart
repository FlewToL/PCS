import 'package:flutter/material.dart';

void main() {
  runApp(const SecondApp());
}

class SecondApp extends StatelessWidget {
  const SecondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
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
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
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
                  fillColor: const Color(0xffe9ecef),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Логин',
                  labelStyle: const TextStyle(
                    color: Color(0xE79396A5),
                    fontSize: 18,
                  ),
                ),
              ),

              // ЧАСТЬ КОДА СПЕЦИАЛЬНО УБРАНА 
              
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                width: 380,
                child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Регистрация',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: const Text('Восстановить пароль',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
