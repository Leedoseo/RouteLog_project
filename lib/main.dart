import 'package:flutter/material.dart';
import 'package:routelog_project/core/theme/app_theme.dart';
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
      theme: buildAppTheme(), // 전역 색상/컴포넌트 스타일 정의
      home: const HomeScreen(), // 최초 진입 화면
    );
  }
}