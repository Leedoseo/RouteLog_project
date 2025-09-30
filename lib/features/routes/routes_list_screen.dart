import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/core/navigation/app_router.dart';
import 'package:routelog_project/core/utils/notifier_provider.dart';
import 'package:routelog_project/features/routes/state/routes_controller.dart';
import 'package:routelog_project/core/data/models/route_log.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final controller = NotifierProvider.of<RoutesController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('루트'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: '알림',
          ),
        ],
      ),
      body: AppBackground(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final loading = controller.loading;
            final items = controller.items;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                // 검색바
                RouteSearchBar(
                  initialText: controller.query,
                  onSubmitted: controller.setQuery,
                ),
                const SizedBox(height: 12),

                // 필터바(정렬/필터/태그) — 지금은 정렬만 동작
                RoutesFilterBar(
                  onSortTap: () => _openSortSheet(context, controller),
                  onFilterTap: () => _openNotImpl(context, '필터'),
                  onTagTap: () => _openNotImpl(context, '태그'),
                ),
                const SizedBox(height: 16),

                Text('최근', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),

                if (loading)
                  ...List.generate(3, (i) => const _SkeletonTile()).expand((e) => [e, const SizedBox(height: 8)]).toList()
                else if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('결과가 없어요', style: t.bodyMedium),
                    ),
                  )
                else
                  ..._buildList(items, context),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildList(List<RouteLog> items, BuildContext context) {
    return [
      for (int i = 0; i < items.length; i++)
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
          child: RouteListTile(
            title: items[i].title,
            meta: _metaText(items[i]),
            distanceText: _km(items[i].distanceMeters),
            paceText: items[i].avgPaceSecPerKm == null ? '-' : _pace(items[i].avgPaceSecPerKm!),
            isFavorited: i == 0,
            onTap: () => Navigator.pushNamed(context, Routes.routeDetail(items[i].id)),
            onExport: () => _snack(context, '내보내기(목업)'),
            onShare: () => _snack(context, '공유(목업)'),
            onDelete: () => _snack(context, '삭제(목업)'),
            onToggleFavorite: (fav) => _snack(context, fav ? '즐겨찾기 추가' : '즐겨찾기 해제'),
          ),
        ),
    ];
  }

  static String _km(double meters) {
    final km = meters / 1000.0;
    return km >= 10 ? '${km.toStringAsFixed(0)}km' : '${km.toStringAsFixed(2)}km';
  }

  static String _pace(double secPerKm) {
    final m = (secPerKm ~/ 60);
    final s = (secPerKm % 60).round().toString().padLeft(2, '0');
    return "$m'$s\"/km";
  }

  static String _metaText(RouteLog r) {
    final d = _km(r.distanceMeters);
    final t = _dur(r.movingTime);
    final p = r.avgPaceSecPerKm == null ? '-' : _pace(r.avgPaceSecPerKm!);
    return '$d · $t · $p';
  }

  static String _dur(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  void _openSortSheet(BuildContext context, RoutesController c) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('날짜 최신순'),
              value: 'date_desc',
              groupValue: c.sort,
              onChanged: (v) {
                Navigator.pop(context);
                c.setSort(v!);
              },
            ),
            RadioListTile<String>(
              title: const Text('거리 내림차순'),
              value: 'distance_desc',
              groupValue: c.sort,
              onChanged: (v) {
                Navigator.pop(context);
                c.setSort(v!);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _openNotImpl(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name 시트는 다음 단계에서 연결')));
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
    );
  }
}
