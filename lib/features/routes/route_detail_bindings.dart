import 'package:flutter/material.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/core/data/models/route_log.dart';
import 'package:routelog_project/features/routes/route_detail_screen.dart';

class RouteDetailBindings extends StatefulWidget {
  const RouteDetailBindings({super.key, required this.routeId});
  final String routeId;

  @override
  State<RouteDetailBindings> createState() => _RouteDetailBindingsState();
}

class _RouteDetailBindingsState extends State<RouteDetailBindings> {
  Future<RouteLog?>? _future;

  @override
  void initState() {
    super.initState();
    _future = RepoRegistry.I.routeRepo.getById(widget.routeId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RouteLog?>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final data = snap.data;
        if (data == null) {
          return const _NotFound();
        }
        return RouteDetailScreen.fromModel(model: data);
      },
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('해당 루트를 찾을 수 없습니다.')),
    );
  }
}
