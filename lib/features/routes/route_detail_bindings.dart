import 'package:flutter/material.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/core/utils/notifier_provider.dart';
import 'package:routelog_project/features/routes/state/route_detail_controller.dart';
import 'package:routelog_project/features/routes/route_detail_screen.dart';

class RouteDetailBindings extends StatefulWidget {
  final String routeId;
  const RouteDetailBindings({
    super.key,
    required this.routeId,
  });
  
  @override
  State<RouteDetailBindings> createState() => _RouteDetailBindingsState();
}

class _RouteDetailBindingsState extends State<RouteDetailBindings> {
  late final RouteDetailController controller;
  
  @override
  void initState() {
    super.initState();
    controller = RouteDetailController(repo: RepoRegistry.I.routeRepo);
    controller.load(widget.routeId);
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return NotifierProvider<RouteDetailController>(
      notifier: controller,
      child: RouteDetailScreen(routeId: widget.routeId),
    );
  }
}