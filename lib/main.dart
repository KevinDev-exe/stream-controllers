import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/coffee_orders/presentation/pages/coffee.dart';

void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Orders Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CoffeePage(),
    );
  }
}