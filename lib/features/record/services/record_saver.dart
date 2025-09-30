import 'package:routelog_project/core/data/models/route_log.dart';
import 'package:routelog_project/core/data/models/latlng_dto.dart';
import 'package:routelog_project/core/data/models/tag.dart';
import 'package:routelog_project/core/data/repository/i_route_repository.dart';
import 'package:routelog_project/features/record/state/record_controller.dart';

class RecordSaver {
  final IRouteRepository repo;
  RecordSaver({required this.repo});

  /// RecordController 상태를 RouteLog 스키마로 변환해 저장하고, 저장된 엔티티 반환
  Future<RouteLog> saveFromController(
      RecordController c, {
        String? title,
        List<Tag> tags = const [],
        String source = 'recorded',
        String? notes,
      }) async {
    final now = DateTime.now();
    final startedAt = now.subtract(c.elapsed);
    final endedAt = now;

    final pathDtos = c.path
        .map((p) => LatLngDto(lat: p.latitude, lng: p.longitude))
        .toList(growable: false);

    final log = RouteLog(
      id: '', // repo.create가 새 id 부여
      title: title ?? _defaultTitle(startedAt),
      startedAt: startedAt,
      endedAt: endedAt,
      path: pathDtos,
      distanceMeters: c.distanceMeters,
      movingTime: c.elapsed,
      avgPaceSecPerKm: c.paceSecPerKm,
      tags: tags,
      source: source,
      notes: notes,
    );

    return await repo.create(log);
  }

  String _defaultTitle(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '기록 $y-$m-$d $hh:$mm';
  }
}
