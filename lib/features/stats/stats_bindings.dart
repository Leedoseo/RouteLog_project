import 'package:flutter/material.dart';
import 'package:routelog_project/core/utils/notifier_provider.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/features/stats/state/stats_controller.dart';
import 'package:routelog_project/features/stats/stats_screen.dart';

class StatsBindings extends StatefulWidget {
  const StatsBindings({super.key});

  @override
  State<StatsBindings> createState() => _StatsBindingsState();
}

class _StatsBindingsState extends State<StatsBindings> {
  late final StatsController controller;

  @override
  void initState() {
    super.initState();
    controller = StatsController(repo: RepoRegistry.I.routeRepo);
    controller.init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotifierProvider<StatsController>(
      notifier: controller,
      child: const StatsScreen(),
    );
  }
}
