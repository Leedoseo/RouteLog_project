import 'package:flutter/material.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/core/utils/notifier_provider.dart';
import 'package:routelog_project/features/search/state/route_search_controller.dart';
import 'package:routelog_project/features/search/search_screen.dart';

class SearchBindings extends StatefulWidget {
  const SearchBindings({super.key});

  @override
  State<SearchBindings> createState() => _SearchBindingsState();
}

class _SearchBindingsState extends State<SearchBindings> {
  late final RouteSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = RouteSearchController(repo: RepoRegistry.I.routeRepo);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotifierProvider<RouteSearchController>(
      notifier: controller,
      child: const SearchScreen(),
    );
  }
}
