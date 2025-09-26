import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/settings/widgets/widgets.dart';
import 'package:routelog_project/features/routes/route_import_sheet.dart';
import 'package:routelog_project/features/routes/route_export_sheet.dart';
import 'package:routelog_project/core/theme/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const routeName = "/settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _distanceUnit = "km";

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String _themeModeLabel(ThemeMode m) {
    switch (m) {
      case ThemeMode.system:
        return "시스템";
      case ThemeMode.light:
        return "라이트";
      case ThemeMode.dark:
        return "다크";
    }
  }

  Future<void> _pickThemeMode() async {
    final ctrl = ThemeController.instance;
    ThemeMode temp = ctrl.mode;

    final result = await showModalBottomSheet<ThemeMode>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "테마 모드",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: "닫기",
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: temp,
                    title: const Text("시스템"),
                    onChanged: (v) => setModalState(() => temp = v!),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: temp,
                    title: const Text("라이트"),
                    onChanged: (v) => setModalState(() => temp = v!),
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: temp,
                    title: const Text("다크"),
                    onChanged: (v) => setModalState(() => temp = v!),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("취소"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.of(ctx).pop(temp),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("적용"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null && result != ThemeController.instance.mode) {
      ThemeController.instance.setMode(result); // 전역 테마 즉시 변경
      if (mounted) setState(() {}); // 트레일링 라벨 갱신
      _snack("테마 모드: ${_themeModeLabel(result)}");
    }
  }

  Future<void> _pickDistanceUnit() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String temp = _distanceUnit;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        "거리 단위",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: "닫기",
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    value: "km",
                    groupValue: temp,
                    title: const Text("킬로미터 (km)"),
                    onChanged: (v) => setModalState(() => temp = v!),
                  ),
                  RadioListTile<String>(
                    value: "mi",
                    groupValue: temp,
                    title: const Text("마일 (mi)"),
                    onChanged: (v) => setModalState(() => temp = v!),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("취소"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.of(ctx).pop(temp),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("적용"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null && result != _distanceUnit) {
      setState(() => _distanceUnit = result);
      _snack("거리 단위 변경(목업): $_distanceUnit");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ThemeController.instance.mode; // 현재 모드
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("설정")),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // ── 0) 계정 헤더(파일 내 private 위젯)
            const _AccountHeaderCard(
              name: "홍길동",
              email: "hong@example.com",
            ),
            const SizedBox(height: 16),

            // ── 1) 표시 & 단위
            const SettingsSectionTitle("표시 & 단위"),
            const SizedBox(height: 8),

            SettingsTile(
              leading: Icons.brightness_6_rounded,
              title: "테마 모드",
              subtitle: "시스템/라이트/다크 중 선택",
              trailing: Text(
                _themeModeLabel(themeMode),
                style: t.labelLarge,
              ),
              onTap: _pickThemeMode,
            ),
            const SizedBox(height: 8),

            SettingsTile(
              leading: Icons.straighten_rounded,
              title: "거리 단위",
              subtitle: "러닝/루트의 거리 표기 단위",
              trailing: Text(
                _distanceUnit.toUpperCase(),
                style: t.labelLarge,
              ),
              onTap: _pickDistanceUnit,
            ),

            const SizedBox(height: 24),

            // ── 2) 데이터 관리
            const SettingsSectionTitle("데이터 관리"),
            const SizedBox(height: 8),

            SettingsTile(
              leading: Icons.ios_share_rounded,
              title: "데이터 내보내기",
              subtitle: "GPX/JSON으로 내보내기",
              onTap: () => showRouteExportSheet(context),
            ),
            const SizedBox(height: 8),

            SettingsTile(
              leading: Icons.file_download_rounded,
              title: "데이터 가져오기",
              subtitle: "GPX/JSON에서 가져오기",
              onTap: () => showRouteImportSheet(context, from: "설정"),
            ),

            const SizedBox(height: 24),

            // ── 3) 알림 (샘플 토글 – 실제 기능은 나중에 연결)
            const SettingsSectionTitle("알림"),
            const SizedBox(height: 8),
            SettingsSwitchTile(
              leading: Icons.notifications_active_rounded,
              title: "푸시 알림",
              subtitle: "기록 요약/목표 달성/리마인드",
              value: true, // 목업
              onChanged: (v) => _snack("푸시 알림: $v (목업)"),
            ),

            const SizedBox(height: 24),

            // ── 4) 정보
            const SettingsSectionTitle("정보"),
            const SizedBox(height: 8),

            SettingsTile(
              leading: Icons.info_outline_rounded,
              title: "버전 정보",
              subtitle: "RouteLog 0.1.0 (mock)",
              onTap: () => _snack("버전 정보는 나중에 연결"),
            ),
            const SizedBox(height: 8),

            SettingsTile(
              leading: Icons.description_outlined,
              title: "오픈소스 라이선스",
              subtitle: "사용한 라이브러리 목록 (미구현)",
              onTap: () => _snack("라이선스 화면은 나중에 연결"),
            ),
            const SizedBox(height: 8),

            SettingsTile(
              leading: Icons.privacy_tip_outlined,
              title: "약관 및 개인정보처리방침",
              subtitle: "문서 보기 (미구현)",
              onTap: () => _snack("문서 화면은 나중에 연결"),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────
/// 파일 내부 private 헤더 카드(외부 위젯 추가 없이 바로 적용 가능)
class _AccountHeaderCard extends StatelessWidget {
  const _AccountHeaderCard({
    required this.name,
    required this.email,
    this.onManageAccount,
    this.onLogout,
  });

  final String name;
  final String email;
  final VoidCallback? onManageAccount;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          // 아바타(이니셜)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: cs.outlineVariant),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(name),
              style: t.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 이름/이메일
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800, height: 1.1)),
                const SizedBox(height: 4),
                Text(email, style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant, height: 1.1)),
              ],
            ),
          ),

          // 액션들(목업)
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onManageAccount ?? () {},
            child: const Text("계정"),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            onPressed: onLogout ?? () {},
            child: const Text("로그아웃"),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "?";
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}
