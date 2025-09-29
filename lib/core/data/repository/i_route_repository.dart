import 'package:routelog_project/core/data/models/mdels.dart';

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
}