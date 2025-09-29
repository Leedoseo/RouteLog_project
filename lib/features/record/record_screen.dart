import 'package:flutter/material.dart';
import 'package:routelog_project/features/record/record_finish_sheet.dart';
import 'package:routelog_project/features/record/widgets/widgets.dart'
    show RecordStatusBadge, ControlBar;
import 'package:routelog_project/core/widgets/widgets.dart' show PermissionBanner;
import 'package:routelog_project/features/record/widgets/record_timer_gauge_card.dart';
import 'package:routelog_project/features/record/widgets/map_placeholder.dart';
import 'package:routelog_project/core/navigation/app_router.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});
  static const routeName = "/record";

  @override
  Widget build(BuildContext context) {
    const mockLocationGranted = false;

    // --- 목업 값 ---
    const String durationText = "--:--";
    const String distanceText = "-- km";
    const String paceText = "-- /km";
    const String heartRateText = "-- bpm";
    const double progress = 0.0;

    // --- 레이아웃 파라미터 ---
    const double baseButtonHeight = 72;
    const double buttonHeight = 36; // ← 절반
    const double baseMapHeight = 220;
    final double mapHeight =
        baseMapHeight + (baseButtonHeight - buttonHeight); // 256

    return Scaffold(
      appBar: AppBar(
        title: const Text("기록"),
        actions: [
          IconButton(
            onPressed: () => _notImplemented(context, "설정/권한 안내 (미구현)"),
            icon: const Icon(Icons.info_outline),
            tooltip: "도움말",
          ),
        ],
      ),

      // 상단 콘텐츠는 스크롤, 하단 컨트롤바는 고정
      body: SafeArea(
        child: Column(
          children: [
            // 상단 영역 전체를 ListView로 감싸 스크롤 가능하게
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                children: [
                  const RecordStatusBadge(statusText: "대기중"),
                  const SizedBox(height: 8),

                  MapPlaceholder(height: mapHeight),

                  if (!mockLocationGranted) ...[
                    const SizedBox(height: 8),
                    PermissionBanner(
                      title: "위치 권한이 필요해요",
                      message: "실시간 기록을 위해 위치 접근 권한을 허용해 주세요",
                      actionLabel: "설정",
                      onAction: () =>
                          _notImplemented(context, "권한 요청/이동은 나중에 연결"),
                    ),
                  ],

                  const SizedBox(height: 8),

                  const RecordTimerGaugeCard(
                    progress: progress,
                    durationText: durationText,
                    distanceText: distanceText,
                    paceText: paceText,
                    heartRateText: heartRateText,
                  ),
                ],
              ),
            ),

            // 하단 컨트롤바(고정)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ControlBar(
                buttonHeight: buttonHeight,
                onStart: () => _notImplemented(context, "기록 시작(미구현)"),
                onPause: () => _notImplemented(context, "일시정지 (미구현)"),
                onStop: () async {
                  // 기록 종료 → 요약 시트
                  await showRecordFinishSheet(
                    context,
                    distanceText: "5.20 km",
                    durationText: "28:12",
                    paceText: "5:25 /km",
                  );

                  // ❗ showRecordFinishSheet가 현재 Future<void> 라서 반환값이 없음.
                  //    아래 처리는 “시트 닫힌 뒤 항상 상세로 이동”하는 임시 로직.
                  //    *원한다면* showRecordFinishSheet가 Future<bool>을 반환하게 바꾼 뒤:
                  //    final saved = await showRecordFinishSheet(...);
                  //    if (saved == true) { Navigator.pushNamed(...); }
                  if (!context.mounted) return;
                  Navigator.pushNamed(context, Routes.routeDetail('record_mock_1'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _notImplemented(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
