import 'package:flutter/material.dart';
import 'package:shop_app/src/pages/main_page.dart';

void main() {
  runApp(const MyApp());
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
      home: const MarketPage(),
    );
  }
}

cp -r C:/Users/Romashka/StudioProjects/shop_app/* ThirdApp/

