import 'package:flutter/material.dart';

/// 단일 루트 내보내기 시트

Future<void> showRouteExportSheet(
  BuildContext context, {
  String? routeTitle, // 시트 상단 제목에 표시
}) {
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: false,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      final theme = Theme.of(sheetCtx);
      final cs = theme.colorScheme;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Row(
              children: [
                Expanded(
                  child: Text(
                    routeTitle == null ? "내보내기" : "내보내기 - $routeTitle",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: "닫기",
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(sheetCtx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 옵션 카드들
            _ExportOptionTile(
              icon: Icons.route_rounded,
              title: "GPX로 내보내기",
              subtitle: "루트 좌표를 GPX파일로 저장",
              onTap: () {
                Navigator.of(sheetCtx).pop();
                _snack("GPX 내보내기는 나중에 연결");
              },
            ),
            const SizedBox(height: 8),
            _ExportOptionTile(
              icon: Icons.data_object_rounded,
              title: "JSON으로 내보내기",
              subtitle: "루트 메타/태그/메모 포함",
              onTap: () {
                Navigator.of(sheetCtx).pop();
                _snack("JSON 내보내기는 나중에 연결");
              },
            ),
            const SizedBox(height: 8),
            _ExportOptionTile(
              icon: Icons.ios_share_rounded,
              title: "공유",
              subtitle: "다른 앱으로 공유(미구현)",
              onTap: () {
                Navigator.of(sheetCtx).pop();
                _snack("공유는 나중에 연결");
              },
            ),

            const SizedBox(height: 12),

            // 도움 텍스트
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Text(
                "실제 파일 생성/저장은 기능 구현 단계에서 연결할 예정",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      );
    }
  );
}

/// 내보내기 옵션 타일

class _ExportOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ExportOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}