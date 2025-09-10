import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

enum _Unit { km, mi }
enum _ThemePref { system, light, dark }

class _SettingsScreenState extends State<SettingsScreen> {
  _ThemePref _theme = _ThemePref.system; // 현재 선택(목업 상태
  _Unit _unit = _Unit.km;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
      ),
      body: ListView(
        children: [
          // 섹션 : 표시/테마
          const _SectionHeader("표시"),
          RadioListTile<_ThemePref>(
            title: const Text("시스템 설정 따름"),
            subtitle: const Text("디바이스 밝기/다크 설정을 사용"),
            value: _ThemePref.system,
            groupValue: _theme,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _theme = v);
              _snack("테마 적용은 나중에 연결");
            },
          ),
          RadioListTile<_ThemePref>(
            title: const Text("라이트 모드"),
            value: _ThemePref.light,
            groupValue: _theme,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _theme = v);
              _snack("테마 적용은 나중에 연결");
            },
          ),
          RadioListTile<_ThemePref>(
            title: const Text("다크 모드"),
            value: _ThemePref.dark,
            groupValue: _theme,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _theme = v);
              _snack("테마 적용은 나중에 연결");
            },
          ),
          const Divider(height: 1),

          // 섹션 : 단위
          const _SectionHeader("단위"),
          RadioListTile<_Unit>(
            title: const Text("킬로미터 (km)"),
            value: _Unit.km,
            groupValue: _unit,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _unit = v);
              _snack("단위 저장은 나중에 연결");
            },
          ),
          RadioListTile<_Unit>(
            title: const Text("마일 (mi)"),
            value: _Unit.mi,
            groupValue: _unit,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _unit = v);
              _snack("단위 저장은 나중에 연결");
            },
          ),
          const Divider(height: 1),

          // 섹션: 데이터 & 백업
          const _SectionHeader("데이터 & 백업"),
          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            title: const Text("GPX 내보내기"),
            subtitle: const Text("선택한 루트를 GPX 파일로 저장"),
            onTap: () => _snack("내보내기는 나중에 연결"),
          ),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text("백업 만들기"),
            subtitle: const Text("기록/설정을 로컬 백업"),
            onTap: () => _snack("백업은 나중에 연결"),
          ),
          ListTile(
            leading: const Icon(Icons.settings_backup_restore_rounded),
            title: const Text("백업에서 복원"),
            subtitle: const Text("기록/설정을 복원"),
            onTap: () => _snack("복원은 나중에 연결"),
          ),
          const Divider(height: 1),

          const _SectionHeader("정보"),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("버전"),
            subtitle: const Text("RouteLog 0.1.0 (mock)"),
            onTap: () => _snack("자세한 정보는 나중에 연결"),
          ),
          AboutListTile(
            icon: const Icon(Icons.description_outlined),
            applicationName: "RouteLog",
            applicationVersion: "0.1.0(mock)",
            applicationLegalese: "2025 RouteLog Project",
            aboutBoxChildren: const [
              SizedBox(height: 12),
              Text("오픈소스 라이선스는 추후 추가 예정"),
            ],
          ),

          // 하단 여백
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// 작은 섹션 헤더 텍스트
class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}