import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/features/home/home_summary.dart';
import 'package:routelog_project/core/data/models/route_log.dart';

class HomeController {
  final ValueNotifier<HomeSummaryState> state =
  ValueNotifier(const HomeSummaryState.loading());
  final _subs = <StreamSubscription>[];

  HomeController() {
    _load();
    final repo = RepoRegistry.I.routeRepo;
    _subs.add(repo.watch().listen((_) => _load())); // 변경 즉시 새로고침
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    try {
      final repo = RepoRegistry.I.routeRepo;
      final List<RouteLog> routes = await repo.list(sort: 'date_desc');

      if (routes.isEmpty) {
        state.value = const HomeSummaryState.data(HomeSummary.empty);
        return;
      }

      final latest = routes.first;
      final totalKm =
      routes.fold<double>(0, (sum, r) => sum + r.distanceKm);

      final paceValues = <double>[];
      for (final r in routes) {
        if (r.avgPaceSecPerKm != null &&
            r.avgPaceSecPerKm!.isFinite &&
            r.avgPaceSecPerKm! > 0) {
          paceValues.add(r.avgPaceSecPerKm!);
        } else if (r.distanceKm > 0 && r.movingTime > Duration.zero) {
          paceValues.add(r.movingTime.inSeconds / r.distanceKm);
        }
      }
      double? avgPaceSecPerKm;
      if (paceValues.isNotEmpty) {
        avgPaceSecPerKm = paceValues.reduce((a, b) => a + b) / paceValues.length;
      }

      final summary = HomeSummary(
        sessionDuration: latest.movingTime,
        totalDistanceKm: double.parse(totalKm.toStringAsFixed(2)),
        avgPaceSecPerKm: avgPaceSecPerKm,
        avgHr: null,
        lastUpdated: DateTime.now(),
      );

      state.value = HomeSummaryState.data(summary);
    } catch (e) {
      state.value = HomeSummaryState.error(e);
    }
  }

  void dispose() {
    for (final s in _subs) { s.cancel(); }
  }
}
