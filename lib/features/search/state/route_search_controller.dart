import 'package:flutter/foundation.dart';
import 'package:routelog_project/core/data/models/route_log.dart';
import 'package:routelog_project/core/data/repository/i_route_repository.dart';

class RouteSearchController extends ChangeNotifier {
  final IRouteRepository repo;
  RouteSearchController({required this.repo});

  String _query = '';
  bool _loading = false;
  List<RouteLog> _items = [];

  String get query => _query;
  bool get loading => _loading;
  List<RouteLog> get items => _items;

  Future<void> setQuery(String q) async {
    _query = q.trim();
    if (_query.isEmpty) {
      _items = [];
      notifyListeners();
      return;
    }
    _loading = true;
    notifyListeners();
    try {
      _items = await repo.list(query: _query, sort: 'date_desc');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
