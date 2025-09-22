import 'package:flutter/material.dart';
import 'package:routelog_project/features/record/record_finish_sheet.dart';
import 'package:routelog_project/features/record/widgets/widgets.dart';
import 'package:routelog_project/core/widgets/widgets.dart' show PermissionBanner;

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  static const routeName = "/record";

  @override
  Widget build(BuildContext context) {
    const mockLocationGranted = false;

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
        child: Column(
          children: [
            const SizedBox(height: 8),
            const RecordStatusBadge(statusText: "대기중"),
            const SizedBox(height: 8),

            // 지도 + 레코드 배너(오버레이)
            Expanded(
              child: Stack(
                children: [
                  const MapPlaceholder(), // (목업 지도)
                  Positioned(
                    left: 16,
                    right: 16,
                    child: RecordBanner(
                      text: "기록을 시작하려면 ▶ 버튼을 눌러주세요",
                      variant: BannerVariant.idle,
                      onTap: () => _notImplemented(context, "배너 탭 (미구현)"),
                    ),
                  ),
                ],
              ),
            ),

            // 권한 배너(옵션)
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
            const MetricsPanel(
              distanceText: "-- km",
              durationText: "--:--",
              paceText: "-- /km",
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ControlBar(
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
        ),
      ),
    );
  }
}

void _notImplemented(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
