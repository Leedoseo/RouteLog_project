import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/edit_note_sheet.dart';
import 'package:routelog_project/features/routes/route_export_sheet.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/core/data/models/models.dart';

/// Route 액션 시트
/// - 내보내기(공유/GPX) → `showRouteExportSheet`
/// - 메모/태그 편집 → `showEditNoteSheet`
/// - 삭제 → 확인 다이얼로그 후 실제 삭제 + 스낵바 Undo
Future<void> showRouteActionsSheet(
    BuildContext context, {
      required RouteLog route,          // 실제 삭제/복원에 사용
      String? routeTitle,               // 내보내기 시트 헤더 표기용(옵션)
      String? memoText,                 // 편집 초기 메모
      List<String>? availableTags,      // 편집: 선택 가능한 태그
      Set<String>? selectedTags,        // 편집: 처음 선택된 태그
      VoidCallback? onDeleted,          // (옵션) 삭제 완료 콜백
    }) {
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) {
      final cs = Theme.of(sheetCtx).colorScheme;

      // 삭제 확인 → 실제 삭제(+Undo) 처리
      Future<void> _confirmDelete() async {
        final ok = await showDialog<bool>(
          context: sheetCtx,
          builder: (dCtx) => AlertDialog(
            title: const Text('삭제하시겠어요?'),
            content: Text('‘${route.title}’ 루트를 삭제하면 복구할 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dCtx).pop(false),
                child: const Text('취소'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(dCtx).pop(true),
                child: const Text('삭제'),
              ),
            ],
          ),
        );

        if (ok == true) {
          // 시트 먼저 닫기
          Navigator.of(sheetCtx).pop();

          final repo = RepoRegistry.I.routeRepo;
          final backup = route; // Undo용 백업 (동일 id로 복원)

          try {
            await repo.delete(route.id);

            if (!context.mounted) return;

            // Undo 제공
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('루트를 삭제했습니다.'),
                action: SnackBarAction(
                  label: '되돌리기',
                  onPressed: () async {
                    try {
                      await repo.create(backup); // 같은 id로 복원
                    } catch (e) {
                      if (context.mounted) {
                        _snack('되돌리기 실패: $e');
                      }
                    }
                  },
                ),
              ),
            );

            // 외부에서 필요하면 후처리
            onDeleted?.call();
          } catch (e) {
            if (!context.mounted) return;
            _snack('삭제 실패: $e');
          }
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Text(
                  '루트 액션',
                  style: Theme.of(sheetCtx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 내보내기 (공유/GPX 통합)
          ListTile(
            leading: const Icon(Icons.ios_share_rounded),
            title: const Text('내보내기'),
            onTap: () {
              Navigator.of(sheetCtx).pop();
              Future.microtask(() => showRouteExportSheet(
                context,
                routeTitle: routeTitle ?? route.title,
              ));
            },
          ),

          // 편집 (메모+태그)
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('편집하기'),
            onTap: () async {
              Navigator.of(sheetCtx).pop(); // 시트 닫기
              await showEditNoteSheet(
                context,
                initialText: memoText,
                availableTags: availableTags,
                initialSelectedTags: selectedTags,
              );
            },
          ),

          // 삭제
          ListTile(
            leading: Icon(Icons.delete_forever_rounded, color: cs.error),
            title: Text('삭제', style: TextStyle(color: cs.error)),
            onTap: _confirmDelete, // 실제 삭제 연결
          ),

          const Divider(height: 1),

          // 취소
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(sheetCtx).pop(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('취소'),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
