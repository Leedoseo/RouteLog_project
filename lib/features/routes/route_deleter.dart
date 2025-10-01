import 'package:flutter/material.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/core/data/models/models.dart';

/// Route 삭제 유틸 (확인 다이얼로그 + 삭제 + 토스트 + 선택적 Undo)
class RouteDeleter {
  RouteDeleter._();
  static final I = RouteDeleter._();

  /// [withUndo]가 true면 스낵바에서 되돌리기 제공
  Future<void> confirmAndDelete(
      BuildContext context, {
        required RouteLog route,
        bool withUndo = true,
      }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('루트 삭제'),
        content: Text('‘${route.title}’ 루트를 삭제할까요? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.delete_forever_rounded),
            label: const Text('삭제'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final repo = RepoRegistry.I.routeRepo;

    // 원본 백업(Undo용)
    final backup = route;

    try {
      await repo.delete(route.id);

      if (!context.mounted) return;

      if (withUndo) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('루트를 삭제했습니다.'),
            action: SnackBarAction(
              label: '되돌리기',
              onPressed: () async {
                // 같은 id로 복원 (FileRouteRepository.create는 충돌 없으면 기존 id 유지)
                await repo.create(backup);
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('루트를 삭제했습니다.')));
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제 실패: $e')));
    }
  }
}
