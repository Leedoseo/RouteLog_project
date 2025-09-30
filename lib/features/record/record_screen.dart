import 'package:flutter/material.dart';
import 'package:routelog_project/features/record/record_finish_sheet.dart';
import 'package:routelog_project/features/record/widgets/widgets.dart'
    show RecordStatusBadge, ControlBar;
import 'package:routelog_project/core/widgets/widgets.dart' show PermissionBanner;
import 'package:routelog_project/features/record/widgets/record_timer_gauge_card.dart';
import 'package:routelog_project/features/record/widgets/map_placeholder.dart';

import 'package:routelog_project/core/widgets/async_view.dart';
import 'package:routelog_project/core/widgets/error_view.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});
  static const routeName = "/record";

  @override
  Widget build(BuildContext context) {
    const mockLocationGranted = false;

    // 목업 값
    const String durationText = "--:--";
    const String distanceText = "-- km";
    const String paceText = "-- /km";
    const String heartRateText = "-- bpm";
    const double progress = 0.0;

    // 레이아웃 파라미터
    const double baseButtonHeight = 72;
    const double buttonHeight = 36;
    const double baseMapHeight = 220;
    final double mapHeight = baseMapHeight + (baseButtonHeight - buttonHeight);

    // M8 상태 값 (컨트롤러 붙이면 교체)
    final bool loading = false;
    final Object? error = null;

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
      body: SafeArea(
        child: AsyncView(
          loading: loading,
          error: error,
          errorView: ErrorView(
            message: "기록 화면을 불러오지 못했어요.",
            onRetry: () {
              // controller.initPermission();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('다시 시도(목업)')),
              );
            },
          ),
          childBuilder: (_) {
            return Column(
              children: [
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
                          onAction: () => _notImplemented(context, "권한 요청/이동은 나중에 연결"),
                        ),
                      ],

                      const SizedBox(height: 8),

                      RecordTimerGaugeCard(
                        progress: progress,
                        durationText: durationText,
                        distanceText: distanceText,
                        paceText: paceText,
                        heartRateText: heartRateText,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ControlBar(
                    buttonHeight: buttonHeight,
                    onStart: () => _notImplemented(context, "기록 시작(미구현)"),
                    onPause: () => _notImplemented(context, "일시정지 (미구현)"),
                    onStop: () async {
                      await showRecordFinishSheet(
                        context,
                        distanceText: "5.20 km",
                        durationText: "28:12",
                        paceText: "5:25 /km",
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void _notImplemented(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
