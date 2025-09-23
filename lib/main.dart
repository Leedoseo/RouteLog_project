import 'package:flutter/material.dart';
import 'package:routelog_project/core/theme/app_theme.dart';
import 'package:routelog_project/core/theme/theme_controller.dart';
import 'package:routelog_project/features/home/home_screen.dart';

void main() {
  runApp(const RouteLogApp());
}

class RouteLogApp extends StatelessWidget {
  const RouteLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = ThemeController.instance; // ★ 싱글톤 컨트롤러
    return AnimatedBuilder(
      animation: ctrl, // ChangeNotifier 구독
      builder: (_, __) {
        return MaterialApp(
          title: "RouteLog",
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: ctrl.mode, // ★ 현재 ThemeMode
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
