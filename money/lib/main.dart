import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MoneyApp());
}

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),

      home: const HomeScreen(),
    );
  }
}
