import 'dart:async';
import 'package:routelog_project/core/data/models/models.dart';

abstract class IRouteRepository {
  Future<List<RouteLog>> list({
    String? query,
    String? sort,
    List<String>? tagIds,
  });

  Future<RouteLog?> getById(String id);
  Future<RouteLog> create(RouteLog log);
  Future<RouteLog> update(RouteLog log);
  Future<void> delete(String id);

  /// 레포 변경 스트림(생성/수정/삭제 시 이벤트 발행)
  /// Home 등에서 구독하면 즉시 UI 새로고침 가능
  Stream<void> watch();
}
