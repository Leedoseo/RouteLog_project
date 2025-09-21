import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/widgets/add_sheet_item.dart';

/// 루트 추가 시트(목업)

Future<void> showRouteAddSheet (BuildContext context) {
  // 바텀시트 외부 컨텍스트에서 스낵바를 띄우기 위해 보관
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Row(
              children: [
                Text(
                  "루트 추가",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: "닫기",
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(sheetCtx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 항목들
            AddSheetItem(
              icon: Icons.play_arrow_rounded,
              title: "기록 시작",
              subtitle: "실시간으로 경로를 기록합니다.",
              onTap: () {
                _snack("기록 시작은 나중에 연결");
                Navigator.of(sheetCtx).pop();
              },
            ),
            const SizedBox(height: 8),
            AddSheetItem(
              icon: Icons.play_arrow_rounded,
              title: "GPX 가져오기",
              subtitle: "파일에서 경로를 가져옵니다.",
              onTap: () {
                _snack("GPX 가져오기는 나중에 연결");
                Navigator.of(sheetCtx).pop();
              },
            ),
            const SizedBox(height: 8),
            AddSheetItem(
              icon: Icons.play_arrow_rounded,
              title: "수동으로 만들기",
              subtitle: "이름/태그/거리/시간을 직접 입력",
              onTap: () {
                _snack("수동 생성은 나중에 연결");
                Navigator.of(sheetCtx).pop();
              },
            ),

            const SizedBox(height: 12),
            // 도움말
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "실제 파일 선택/네비게이션은 이후 단계에서 연결",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }
  );
}