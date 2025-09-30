import 'dart:math';
import 'package:routelog_project/core/data/models/models.dart';
import 'package:routelog_project/core/data/repository/i_route_repository.dart';
import 'package:routelog_project/core/data/local/json_store.dart';

/// JSON 파일 기반 Route 레포지토리
class FileRouteRepository implements IRouteRepository {
  FileRouteRepository._(this._store);

  /// 파일을 열어 레포 인스턴스를 만든다. (static 이름 충돌 회피 위해 create → open 으로 사용)
  static Future<FileRouteRepository> open({required String filename}) async {
    final docs = await getAppDocsPath();
    final store = JsonStore('$docs/$filename');
    return FileRouteRepository._(store);
  }

  final JsonStore _store;

  Future<List<RouteLog>> _readAll() async {
    final raw = await _store.readList();
    return raw
        .map((e) => RouteLog.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> _writeAll(List<RouteLog> items) async {
    final arr = items.map((e) => e.toJson()).toList();
    await _store.writeList(arr);
  }

  @override
  Future<List<RouteLog>> list({
    String? query,
    String? sort,
    List<String>? tagIds,
  }) async {
    var items = await _readAll();

    if (tagIds != null && tagIds.isNotEmpty) {
      final set = tagIds.toSet();
      items = items.where((e) {
        final ids = e.tags.map((t) => t.id).toSet();
        return set.every(ids.contains);
      }).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      items = items.where((e) => e.title.toLowerCase().contains(q)).toList();
    }

    switch (sort) {
      case 'date_asc':
        items.sort((a, b) => a.startedAt.compareTo(b.startedAt));
        break;
      case 'distance_desc':
        items.sort((a, b) => b.distanceMeters.compareTo(a.distanceMeters));
        break;
      case 'distance_asc':
        items.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
        break;
      case 'date_desc':
      default:
        items.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    }

    return items;
  }

  @override
  Future<RouteLog?> getById(String id) async {
    final items = await _readAll();
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RouteLog> create(RouteLog log) async {
    final items = await _readAll();

    // id 비어있거나 충돌 시 새 id 부여
    final needsNewId = log.id.isEmpty || items.any((e) => e.id == log.id);
    final newId = needsNewId ? _genId() : log.id;

    final saved = log.copyWith(id: newId);
    items.add(saved);
    await _writeAll(items);
    return saved;
  }

  @override
  Future<RouteLog> update(RouteLog log) async {
    final items = await _readAll();
    final idx = items.indexWhere((e) => e.id == log.id);
    if (idx == -1) {
      // 없으면 생성처럼 동작
      return await create(log);
    }
    items[idx] = log;
    await _writeAll(items);
    return log;
  }

  @override
  Future<void> delete(String id) async {
    final items = await _readAll();
    items.removeWhere((e) => e.id == id);
    await _writeAll(items);
  }

  String _genId() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final rand = Random().nextInt(100000).toString().padLeft(5, '0');
    return 'rl_${ts}_$rand';
  }
}
