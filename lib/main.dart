import 'package:flutter/material.dart';
import 'package:routelog_project/features/home/home_screen.dart';

void main() {
  runApp(const RouteLogApp());
}

class RouteLogApp extends StatelessWidget {
  const RouteLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RouteLogApp",
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}