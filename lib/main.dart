import 'package:flutter/material.dart';
import 'package:routelog_project/core/theme/app_theme.dart';
import 'package:routelog_project/core/theme/theme_controller.dart';
import 'package:routelog_project/core/navigation/app_router.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.load();
  await RepoRegistry.I.init(seedIfEmpty: false); // ← 추가 (최초 한 번 시드하고 싶으면 true)
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
