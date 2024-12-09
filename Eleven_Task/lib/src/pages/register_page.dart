import 'package:shop_app/src/service/auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void signUp() async {
// prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirm_password = _confirmPasswordController.text;

    if (password != confirm_password) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }

    try {
      await authService.signUpWithEmailPassword(email, password);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error : $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Регистрация",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
        children: [
          const SizedBox(height: 140),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEAEAEA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              labelText: 'Электронная почта',
              labelStyle: const TextStyle(
                color: Color(0xFF757575),
                fontSize: 20,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF676767),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEAEAEA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              labelText: 'Пароль',
              labelStyle: const TextStyle(
                color: Color(0xFF757575),
                fontSize: 20,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF676767),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFEAEAEA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              labelText: 'Повторите пароль',
              labelStyle: const TextStyle(
                color: Color(0xFF757575),
                fontSize: 20,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF676767),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: false,
                onChanged: (bool? value) {},
                checkColor: const Color(0xFF60CA00),
                side: const BorderSide(color: Color(0xFF60CA00), width: 2),
              ),
              const Text(
                'Запомнить меня',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF60CA00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            width: 380,
            child: ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF60CA00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Зарегистрироваться',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
