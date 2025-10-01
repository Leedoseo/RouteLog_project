import 'dart:async';
import 'dart:math';
import 'package:routelog_project/core/data/models/models.dart';
import 'package:routelog_project/core/data/repository/i_route_repository.dart';

/// 메모리 기반 Mock 구현 (+ watch 지원)
class MockRouteRepository implements IRouteRepository {
  final List<RouteLog> _items = [];
  final StreamController<void> _changes = StreamController<void>.broadcast();
  @override
  Stream<void> watch() => _changes.stream;
  void _emitChange() { if (!_changes.isClosed) { try { _changes.add(null); } catch (_) {} } }

  MockRouteRepository() {
    if (_items.isEmpty) {
      final now = DateTime.now();
      final river = Tag(id: 'river', name: '강변', color: 0xFF2196F3);
      final night = Tag(id: 'night', name: '야간', color: 0xFF673AB7);

      _items.addAll([
        RouteLog(
          id: 'seed_1',
          title: '강변 러닝 코스 1',
          startedAt: now.subtract(const Duration(days: 1, hours: 2)),
          endedAt:   now.subtract(const Duration(days: 1, hours: 1, minutes: 31)),
          path: const [
            LatLngDto(lat: 37.5299, lng: 126.9644),
            LatLngDto(lat: 37.5315, lng: 126.9782),
            LatLngDto(lat: 37.5371, lng: 126.9911),
          ],
          distanceMeters: 5200,
          movingTime: const Duration(minutes: 28, seconds: 12),
          avgPaceSecPerKm: (28 * 60 + 12) / 5.2,
          tags: [river],
          source: 'seed',
          notes: '시드 데이터',
        ),
        RouteLog(
          id: 'seed_2',
          title: '야간 10K',
          startedAt: now.subtract(const Duration(days: 3, hours: 1)),
          endedAt:   now.subtract(const Duration(days: 3, minutes: 4)),
          path: const [
            LatLngDto(lat: 37.5665, lng: 126.9780),
            LatLngDto(lat: 37.5700, lng: 126.9820),
            LatLngDto(lat: 37.5740, lng: 126.9860),
          ],
          distanceMeters: 10200,
          movingTime: const Duration(minutes: 56, seconds: 31),
          avgPaceSecPerKm: (56 * 60 + 31) / 10.2,
          tags: [night],
          source: 'seed',
          notes: null,
        ),
      ]);
      // 필요시 _emitChange();
    }
  }

  @override
  Future<List<RouteLog>> list({
    String? query,
    String? sort,
    List<String>? tagIds,
  }) async {
    Iterable<RouteLog> r = _items;

    if (tagIds != null && tagIds.isNotEmpty) {
      r = r.where((e) {
        final ids = e.tags.map((t) => t.id).toSet();
        return tagIds.every(ids.contains);
      });
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      r = r.where((e) => e.title.toLowerCase().contains(q));
    }

    switch (sort) {
      case 'date_asc':
        r = r.toList()..sort((a, b) => a.startedAt.compareTo(b.startedAt));
        break;
      case 'distance_desc':
        r = r.toList()..sort((a, b) => b.distanceMeters.compareTo(a.distanceMeters));
        break;
      case 'distance_asc':
        r = r.toList()..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
        break;
      case 'date_desc':
      default:
        r = r.toList()..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    }

    return List<RouteLog>.from(r);
  }

  @override
  Future<RouteLog?> getById(String id) async {
    try { return _items.firstWhere((e) => e.id == id); } catch (_) { return null; }
  }

  @override
  Future<RouteLog> create(RouteLog log) async {
    final needsNewId = log.id.isEmpty || _items.any((e) => e.id == log.id);
    final saved = log.copyWith(id: needsNewId ? _genId() : log.id);
    _items.add(saved);
    _emitChange();
    return saved;
  }

  @override
  Future<RouteLog> update(RouteLog log) async {
    final idx = _items.indexWhere((e) => e.id == log.id);
    if (idx == -1) {
      final created = await create(log);
      return created;
    }
    _items[idx] = log;
    _emitChange();
    return log;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
    _emitChange();
  }

  String _genId() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final rand = Random().nextInt(100000).toString().padLeft(5, '0');
    return 'rl_${ts}_$rand';
  }

  void dispose() { _changes.close(); }
}
