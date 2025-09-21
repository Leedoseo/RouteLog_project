import 'package:flutter/material.dart';
import 'package:routelog_project/features/settings/widgets/widgets.dart';
import 'package:routelog_project/features/routes/route_import_sheet.dart';
import 'package:routelog_project/features/routes/route_export_sheet.dart';

/// 설정 화면(카드 스타일 목업으로 변경)
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const routeName = "/settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 목업용 로컬 상태
  bool _darkMode = false;
  String _distanceUnit = "km";

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickDistanceUnit() async {
    /// 간단 라디오 시트(목업)
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
                  /// 시트 헤더
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

                  /// 라디오 목록
                  RadioListTile(
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

                  // 하단 액션
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
    return Scaffold(
      appBar: AppBar(title: const Text("설정")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          /// 섹션1: 표시/단위
          const SettingsSectionTitle("표시 & 단위"),
          const SizedBox(height: 8),

          /// 다크 모드 스위치
          SettingsSwitchTile(
            leading: Icons.dark_mode_rounded,
            title: "다크 모드",
            subtitle: "시스템 테마와 별도로 앱 테마를 지정합니다",
            value: _darkMode,
            onChanged: (v) {
              setState(() => _darkMode = v);
              _snack("다크 모드 토글(목업): $v");
            },
          ),
          const SizedBox(height: 8),

          /// 거리 단위 선택
          SettingsTile(
            leading: Icons.straighten_rounded,
            title: "거리 단위",
            subtitle: "러닝/루트의 거리 표기 단위",
            trailing: Text(
              _distanceUnit.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onTap: _pickDistanceUnit,
          ),

          const SizedBox(height: 24),

          /// 섹션 2: 백업/내보내기
          const SettingsSectionTitle("백업 & 내보내기"),
          const SizedBox(height: 8),

          SettingsTile(
            leading: Icons.ios_share_rounded,
            title: "데이터 내보내기",
            subtitle: "GPX/JSON으로 내보내기 (미구현)",
            onTap: () => showRouteExportSheet(context),
          ),
          const SizedBox(height: 8),

          SettingsTile(
            leading: Icons.file_download_rounded,
            title: "데이터 가져오기",
            subtitle: "GPX/JSON으로 가져오기 (미구현)",
            onTap: () => showRouteImportSheet(context, from: "설정"),
          ),
          const SizedBox(height: 24),

          /// 섹션 3: 정보
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
    );
  }
}