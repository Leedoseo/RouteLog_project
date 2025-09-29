import 'package:flutter/material.dart';
import 'package:routelog_project/core/data/models/route_log.dart';
import 'package:routelog_project/core/data/repository/i_route_repository.dart';

class RouteDetailController extends ChangeNotifier {
  final IRouteRepository repo;
  RouteDetailController({required this.repo});

  RouteLog? _route;
  bool _loading = false;

  RouteLog? get route => _route;
  bool get loading => _loading;

  Future<void> load(String id) async {
    _loading = true;
    notifyListeners();
    try {
      _route = await repo.getById(id);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}