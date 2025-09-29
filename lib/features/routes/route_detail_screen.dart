import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/core/decoration/app_background.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key, required this.routeId});

  /// 네임드 라우팅(/route/<id>)으로 전달된 루트 ID
  final String routeId;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('루트 상세'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_location_alt),
            tooltip: '편집(목업)',
          ),
        ],
      ),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            // 라우트 식별자 표시(임시) — 나중에 실제 제목으로 교체
            Text('ID: $routeId', style: t.labelSmall),
            const SizedBox(height: 8),

            const RouteHeaderMap(height: 220),
            const SizedBox(height: 12),

            const RouteMetaPanel(
              distanceText: '5.20 km',
              durationText: '28:12',
              paceText: '5\'25"/km',
              elevationText: '+64 m',
            ),
            const SizedBox(height: 12),

            const RouteElevationCard(),
            const SizedBox(height: 12),

            RouteActionBar(
              isFavorited: false,
              onToggleFavorite: (fav) => _snack(context, fav ? '즐겨찾기 추가' : '즐겨찾기 해제'),
              onExport: () => _snack(context, '내보내기(목업)'),
              onShare: () => _snack(context, '공유(목업)'),
              onDelete: () => _snack(context, '삭제(목업)'),
            ),

            const SizedBox(height: 24),
            Text('메모', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const RouteNoteCard(
              text: '강변 남단은 바람이 많이 붐. 북단에서 출발하면 반환점에서 역풍.',
            ),
          ],
        ),
      ),
    );
  }

  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
