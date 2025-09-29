import 'dart:async';
import 'dart:math';
import 'package:routelog_project/core/data/models/mdels.dart';
import 'package:routelog_project/core/data/repository/i_route_repository.dart';

class MockRouteRepository implements IRouteRepository {
  final Map<String, RouteLog> _store = {};

  MockRouteRepository() {
    _seed();
  }

  @override
  Future<RouteLog> create(RouteLog log) async {
    _store[log.id] = log;
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return log;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
    await Future<void>.delayed(const Duration(milliseconds: 60));
  }

  @override
  Future<RouteLog?> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    return _store[id];
  }

  @override
  Future<List<RouteLog>> list({String? query, String? sort, List<String>? tagIds}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    Iterable<RouteLog> res = _store.values;

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      res = res.where((e) =>
      e.title.toLowerCase().contains(q) ||
          (e.notes ?? '').toLowerCase().contains(q));
    }
    if (tagIds != null && tagIds.isNotEmpty) {
      res = res.where((e) => e.tags.any((t) => tagIds.contains(t.id)));
    }
    switch (sort) {
      case 'date_desc':
        res = res.toList()..sort((a, b) => b.startedAt.compareTo(a.startedAt));
        break;
      case 'distance_desc':
        res = res.toList()..sort((a, b) => b.distanceMeters.compareTo(a.distanceMeters));
        break;
      default:
        res = res.toList()..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    }
    return res.toList();
  }

  @override
  Future<RouteLog> update(RouteLog log) async {
    _store[log.id] = log;
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return log;
  }

  // ---- seed ----
  void _seed() {
    final random = Random(42);
    List<LatLngDto> pathAround(double lat, double lng) {
      final pts = <LatLngDto>[];
      double accLat = lat;
      double accLng = lng;
      for (int i = 0; i < 80; i++) {
        accLat += (random.nextDouble() - 0.5) * 0.0008;
        accLng += (random.nextDouble() - 0.5) * 0.0008;
        pts.add(LatLngDto(lat: accLat, lng: accLng));
      }
      return pts;
    }

    final tagPark = Tag(id: 't1', name: '공원', color: 0xFF4CAF50);
    final tagNight = Tag(id: 't2', name: '야간', color: 0xFF3F51B5);

    for (int i = 0; i < 12; i++) {
      final start = DateTime.now().subtract(Duration(days: i * 2, hours: random.nextInt(4) + 1));
      final end = start.add(Duration(minutes: 30 + random.nextInt(40)));
      final path = pathAround(37.5665 + i * 0.001, 126.9780 + i * 0.001);
      final dist = 3200 + random.nextInt(5200); // 3.2~8.4km
      final move = Duration(minutes: 30 + random.nextInt(40));
      final pace = move.inSeconds / (dist / 1000.0);

      final route = RouteLog(
        id: 'mock_$i',
        title: '러닝 #$i',
        startedAt: start,
        endedAt: end,
        path: path,
        distanceMeters: dist.toDouble(),
        movingTime: move,
        avgPaceSecPerKm: pace,
        tags: i.isEven ? [tagPark] : [tagNight],
        source: 'recorded',
        notes: i % 3 == 0 ? '컨디션 굿' : null,
      );
      _store[route.id] = route;
    }
  }
}
