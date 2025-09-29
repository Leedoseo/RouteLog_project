enum DistanceUnit { km, mi }

class UserPrefs {
  final DistanceUnit unit;
  final bool autoPause;
  final String themeMode; // 'system' | 'light' | 'dark'

  const UserPrefs({
    required this.unit,
    required this.autoPause,
    required this.themeMode,
  });

  UserPrefs copyWith({DistanceUnit? unit, bool? autoPause, String? themeMode}) => UserPrefs(
    unit: unit ?? this.unit,
    autoPause: autoPause ?? this.autoPause,
    themeMode: themeMode ?? this.themeMode,
  );
}
