import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GpsAccuracyOption { high, balanced }

class SettingsController extends ChangeNotifier {
  SettingsController._();
  static final SettingsController instance = SettingsController._();

  // 옵션 (기본값)
  GpsAccuracyOption accuracy = GpsAccuracyOption.high;
  bool autoPause = true;
  double autoPauseMinSpeedKmh = 1.5; // 이 속도 미만이 지속되면 일시정지
  int autoPauseGraceSec = 8;         // 몇 초 지속되면 일시정지

  // 키
  static const _kAccuracy = 'settings.accuracy';
  static const _kAutoPause = 'settings.autoPause';
  static const _kAutoPauseSpeed = 'settings.autoPause.speedKmh';
  static const _kAutoPauseGrace = 'settings.autoPause.graceSec';

  Future<void> load() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final acc = sp.getString(_kAccuracy);
      if (acc == 'balanced') accuracy = GpsAccuracyOption.balanced;
      autoPause = sp.getBool(_kAutoPause) ?? autoPause;
      autoPauseMinSpeedKmh = sp.getDouble(_kAutoPauseSpeed) ?? autoPauseMinSpeedKmh;
      autoPauseGraceSec = sp.getInt(_kAutoPauseGrace) ?? autoPauseGraceSec;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _save(void Function() change) async {
    change();
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kAccuracy, accuracy == GpsAccuracyOption.balanced ? 'balanced' : 'high');
    await sp.setBool(_kAutoPause, autoPause);
    await sp.setDouble(_kAutoPauseSpeed, autoPauseMinSpeedKmh);
    await sp.setInt(_kAutoPauseGrace, autoPauseGraceSec);
  }

  void setAccuracy(GpsAccuracyOption v) => _save(() => accuracy = v);
  void setAutoPause(bool v) => _save(() => autoPause = v);
  void setAutoPauseSpeed(double kmh) => _save(() => autoPauseMinSpeedKmh = kmh);
  void setAutoPauseGrace(int sec) => _save(() => autoPauseGraceSec = sec);
}
