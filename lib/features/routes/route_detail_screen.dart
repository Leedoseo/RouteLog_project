import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/core/decoration/app_background.dart';

// 모델을 받아서 타이틀로 매핑하는 fromModel 팩토리를 위해 import
import 'package:routelog_project/core/data/models/route_log.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key, required this.title});
  final String title;

  /// ✅ 바인딩/기존 호출 호환용: 모델을 받아 화면을 생성
  /// 지금은 타이틀만 매핑하지만, 나중에 필요하면 거리/시간/페이스도 여기서 포맷해 전달하도록 확장 가능.
  factory RouteDetailScreen.fromModel(RouteLog log) {
    return RouteDetailScreen(title: log.title);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_location_alt), tooltip: '편집(목업)'),
        ],
      ),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const RouteHeaderMap(height: 220),
            const SizedBox(height: 12),
            const RouteMetaPanel(
              distanceText: '5.20 km',
              durationText: '28:12',
              paceText: '5\'25"/km',
              elevationText: '+64 m',
            ),
            const SizedBox(height: 12),
            // 고도 프로파일은 제거(원하면 재삽입)
            // const RouteElevationCard(),
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
