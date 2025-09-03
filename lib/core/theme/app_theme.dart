import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A7AFE)),
    useMaterial3: true,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      centerTitle: false, // 타이틀 왼쪽 정렬
      elevation: 0, // 그림자 제거
    ),
    cardTheme: const CardTheme(
      elevation: 0,
      margin: EdgeInsets.zero, // Card 기본 마진 제거
      clipBehavior: Clip.antiAlias, // 둥근 모서리
    ),
  );
}