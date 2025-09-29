import 'package:flutter/material.dart';
import 'package:routelog_project/core/utils/notifier_provider.dart';
import 'package:routelog_project/core/data/repository/mock/mock_route_repository.dart';
import 'package:routelog_project/features/routes/state/routes_controller.dart';
import 'package:routelog_project/features/routes/routes_list_screen.dart';

class RoutesBindings extends StatefulWidget {
  const RoutesBindings({super.key});

  @override
  State<RoutesBindings> createState() => _RoutesBindingsState();
}

class _RoutesBindingsState extends State<RoutesBindings> {
  late final RoutesController controller;

  @override
  void initState() {
    super.initState();
    controller = RoutesController(repo: MockRouteRepository());
    // 최초 로드
    controller.load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotifierProvider<RoutesController>(
      notifier: controller,
      child: const RoutesListScreen(),
    );
  }
}