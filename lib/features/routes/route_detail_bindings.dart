import 'package:flutter/material.dart';
import 'package:routelog_project/core/data/models/route_log.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/features/routes/route_detail_screen.dart';

// 선택: M8 컴포넌트로 상태 표시
import 'package:routelog_project/core/widgets/async_view.dart';
import 'package:routelog_project/core/widgets/error_view.dart';

class RouteDetailBindings extends StatefulWidget {
  const RouteDetailBindings({super.key, required this.routeId});
  final String routeId;

  @override
  State<RouteDetailBindings> createState() => _RouteDetailBindingsState();
}

class _RouteDetailBindingsState extends State<RouteDetailBindings> {
  RouteLog? _log;
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _log = await RepoRegistry.I.routeRepo.getById(widget.routeId);
      _error = null;
    } catch (e) {
      _error = e;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AsyncView(
      loading: _loading,
      error: _error,
      errorView: ErrorView(
        message: "루트를 불러오지 못했어요.",
        onRetry: _load,
      ),
      childBuilder: (_) {
        final log = _log;
        if (log == null) {
          // not found 케이스
          return const Scaffold(
            body: Center(child: Text('루트를 찾을 수 없어요')),
          );
        }
        // ✅ 핵심: positional 인자로 전달
        return RouteDetailScreen.fromModel(log);
      },
    );
  }
}
