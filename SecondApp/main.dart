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
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffe7eaed),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Пароль',
                  labelStyle: const TextStyle(
                    color: Color(0xE79396A5),
                    fontSize: 18,
                  ),
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
                    checkColor: const Color(0xFF3E3E3E),
                  ),
                  const Text(
                    'Запомнить меня',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF656565)
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
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),


                  ЧАСТЬ КОДА УБРАНА 

                  
                    )
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          top: 940,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Акулов Р.В. ЭФБО-04-22',
              style: TextStyle(
                  color: Color(0xFFAA00AA),
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ],
    );
  }
}

