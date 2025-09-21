import 'package:flutter/material.dart';

/// 자동 일시정지 안내 다이얼로그
/// 사용 중 이동 없음 감지 -> 사용자 확인

Future<String?> showAutoPauseDialog(BuildContext context, {String? reason}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("자동 일시정지"),
        content: Text(reason ?? "일정 시간 이동이 없어 기록이 일시정지 되었습니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop("resume"),
            child: const Text("재개"),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(ctx).pop("stop"),
            child: const Text("종료"),
          ),
        ],
      );
    }
  );
}