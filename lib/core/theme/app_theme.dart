import 'package:flutter/material.dart';

// 앱 전역 테마
ThemeData buildAppTheme() {
  const seed = Color(0xFF3A7AFE);
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,

    // AppBar: 좌측 정렬, 그림자 제거, 표면색/전경색 일치
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
    ),

    // Card: 기본 마진 제거 + 둥근 모서리 + 그림자 제거
    cardTheme: CardTheme(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // BottomSheet: 우리가 쓰는 편집 시트 라운드 모양과 일치
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      showDragHandle: false,
    ),

    // TextField: 기본 라운드 12
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary),
      ),
    ),

    // 버튼: 높이/라운드 통일
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // 탭: 편집 시트 탭바 가독성 향상
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
    ),

    // 스낵바: 떠있는 형태(우리가 많이 씀)
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),

    // Divider: outlineVariant로 미세한 경계
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
  );
}
