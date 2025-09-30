import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/core/data/models/route_log.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key, required this.title});
  final String title;

  /// 모델 기반 화면 생성용 정적 메서드 (Widget 반환)
  static Widget fromModel({required RouteLog model}) {
    final km = model.distanceMeters / 1000.0;
    final distanceText =
    km >= 10 ? '${km.toStringAsFixed(0)} km' : '${km.toStringAsFixed(2)} km';

    final durationText = _fmtDur(model.movingTime);
    final paceText = model.avgPaceSecPerKm == null
        ? '-'
        : "${(model.avgPaceSecPerKm! ~/ 60)}'"
        "${(model.avgPaceSecPerKm! % 60).round().toString().padLeft(2, '0')}\"/km";

    return _RouteDetailFromModel(
      model: model,
      distanceText: distanceText,
      durationText: durationText,
      paceText: paceText,
    );
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

  static String _fmtDur(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

/// 실제 모델 값으로 그리는 버전
class _RouteDetailFromModel extends StatelessWidget {
  const _RouteDetailFromModel({
    required this.model,
    required this.distanceText,
    required this.durationText,
    required this.paceText,
  });

  final RouteLog model;
  final String distanceText;
  final String durationText;
  final String paceText;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(model.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_location_alt), tooltip: '편집(목업)'),
        ],
      ),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const RouteHeaderMap(height: 220), // M4에서 실제 경로(Polyline) 연동 예정
            const SizedBox(height: 12),
            RouteMetaPanel(
              distanceText: distanceText,
              durationText: durationText,
              paceText: paceText,
              elevationText: '+— m', // 고도는 이후 단계
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
              text: '이번 기록은 MockRepo에 저장된 실데이터를 표시 중입니다.',
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
