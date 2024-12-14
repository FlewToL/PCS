import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shop_app/src/gates/auth_gate.dart';
import 'package:shop_app/src/pages/main_page.dart';
import 'package:shop_app/src/pages/profile_page.dart';
import 'package:shop_app/src/pages/favorites_page.dart';
import 'package:shop_app/src/pages/shopping_cart_page.dart';
import 'package:shop_app/src/objects/favorites_provider_class.dart';
import 'package:shop_app/src/objects/shopping_cart_class.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/service/food_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: "https://yiszhdytjaajmooiysjz.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlpc3poZHl0amFham1vb2l5c2p6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzMjU4NDMsImV4cCI6MjA0ODkwMTg0M30.7__uh-NSARwD9TcoSObfb7tqk7EOSIlkk9Ir7_iYY0k");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => FavoritesProvider(),
        ),
        ChangeNotifierProvider<ShoppingCart>(
          create: (_) => ShoppingCart(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
        ),
      ),
      locale: const Locale('ru'),
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final FoodService _orderService = FoodService();

  late final List<Widget> _widgetOptions = <Widget>[
    const MarketPage(),
    const FavoritePage(),
    ShoppingCartPage(orderService: _orderService), // Передаем orderService
    const AuthGate(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: FaIcon(Icons.search), label: 'Каталог'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: 'Избранное'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Корзина'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Профиль'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF3DE304),
        unselectedItemColor: const Color(0xFF999999),
        onTap: _onItemTapped,
      ),
    );
  }
}
