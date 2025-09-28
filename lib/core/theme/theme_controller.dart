import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱 전역 테마 컨트롤러 (영구 저장 포함)
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  static const _kKey = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  /// 시작 시 1회 호출해서 저장된 모드 로드
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kKey);
    if (saved != null) {
      _mode = _decode(saved);
    } else {
      _mode = ThemeMode.system; // 초기값
    }
  }

  /// 변경 + 저장
  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, _encode(mode));
  }

  // ── 내부: enum ↔︎ String 매핑
  String _encode(ThemeMode m) {
    switch (m) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  ThemeMode _decode(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
