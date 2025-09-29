import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/core/utils/notifier_provider.dart';
import 'package:routelog_project/features/routes/state/route_detail_controller.dart';
import 'package:routelog_project/core/data/models/route_log.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key, required this.routeId});
  final String routeId;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final ctrl = NotifierProvider.of<RouteDetailController>(context);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: ctrl,
          builder: (_, __) {
            final title = ctrl.route?.title ?? '루트 상세';
            return Text(title, maxLines: 1, overflow: TextOverflow.ellipsis);
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_location_alt), tooltip: '편집(목업)'),
        ],
      ),
      body: AppBackground(
        child: AnimatedBuilder(
          animation: ctrl,
          builder: (_, __) {
            if (ctrl.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final RouteLog? data = ctrl.route;
            if (data == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('루트를 찾을 수 없습니다 (id: $routeId)', style: t.bodyMedium),
                ),
              );
            }

            final distanceKm = (data.distanceMeters / 1000.0);
            final distanceText = distanceKm >= 10
                ? '${distanceKm.toStringAsFixed(0)} km'
                : '${distanceKm.toStringAsFixed(2)} km';

            final durationText = _fmtDur(data.movingTime);
            final paceText = (data.avgPaceSecPerKm == null)
                ? '-'
                : _fmtPace(data.avgPaceSecPerKm!);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                const RouteHeaderMap(height: 220),
                const SizedBox(height: 12),

                RouteMetaPanel(
                  distanceText: distanceText,
                  durationText: durationText,
                  paceText: paceText,
                  elevationText: '+64 m', // 목업
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
                RouteNoteCard(text: data.notes ?? '메모가 없어요.'),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _fmtDur(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  static String _fmtPace(double secPerKm) {
    final m = secPerKm ~/ 60;
    final s = (secPerKm % 60).round();
    return "$m'${s.toString().padLeft(2, '0')}\"/km";
  }

  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
