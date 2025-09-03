import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  static const routeName = "/record";

  @override
  Widget build(BuildContext context) {
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
            const RecordStatusBadge(statusText: "대기중"), // 현재 상태 배지
            const SizedBox(height: 8),
            const Expanded(child: MapPlaceholder()), // 지도 영역(미구현)
            const SizedBox(height: 8),
            const MetricsPanel( // 핵심 지표 3개
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
                onStop: () => _notImplemented(context, "종료/저장(미구현)"),
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