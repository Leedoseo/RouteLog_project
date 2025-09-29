import 'package:flutter/material.dart';
import 'package:routelog_project/core/theme/app_theme.dart';
import 'package:routelog_project/core/theme/theme_controller.dart';
import 'package:routelog_project/core/navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.load(); // 저장된 테마 로드
  runApp(const RouteLogApp());
}

class RouteLogApp extends StatelessWidget {
  const RouteLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = ThemeController.instance;

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        return MaterialApp(
          title: 'RouteLog',
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: ctrl.mode, // 저장값 반영
          // 라우터 반영
          initialRoute: Routes.home,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
