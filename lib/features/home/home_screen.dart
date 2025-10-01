import 'dart:async';
import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/core/navigation/app_router.dart';
import 'package:routelog_project/core/data/repository/repo_registry.dart';
import 'package:routelog_project/core/data/models/route_log.dart';

import 'package:routelog_project/features/home/widgets/home_hero_dashboard.dart';
import 'package:routelog_project/features/home/widgets/mini_stat.dart';
import 'package:routelog_project/features/home/widgets/quick_action_button.dart';
import 'package:routelog_project/features/home/widgets/recent_route_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<_HomeData>? _future;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _refresh();
    _sub = RepoRegistry.I.routeRepo.watch().listen((_) => _refresh());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  Future<_HomeData> _load() async {
    final repo = RepoRegistry.I.routeRepo;
    final items = await repo.list(sort: 'date_desc');

    if (items.isEmpty) return const _HomeData.empty();

    final latest = items.first;
    final totalKm = items.fold<double>(0, (sum, r) => sum + r.distanceKm);
    final durationMin = latest.movingTime.inMinutes;
    final progress = (durationMin / 40).clamp(0, 1).toDouble();
    final recent = items.take(3).toList();

    return _HomeData(
      latest: latest,
      totalKm: totalKm,
      durationMinutes: durationMin,
      progress: progress,
      recent: recent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RouteLog'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: AppBackground(
        child: FutureBuilder<_HomeData>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('홈 데이터 로드 실패: ${snap.error}'));
            }

            final data = snap.data ?? const _HomeData.empty();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                HomeHeroDashboard(
                  durationMinutes: data.durationMinutes,
                  progress: data.progress,
                  distanceKm: data.latest?.distanceKm,
                  paceSecPerKm: data.latest?.avgPaceSecPerKm,
                  avgHr: null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: MiniStat(
                        icon: Icons.timer_outlined,
                        label: '세션 시간',
                        value: data.latest != null
                            ? data.latest!.movingTimeText
                            : '00:00',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MiniStat(
                        icon: Icons.directions_run_rounded,
                        label: '누적 거리',
                        value: '${data.totalKm.toStringAsFixed(data.totalKm >= 10 ? 0 : 1)} km',
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: MiniStat(
                        icon: Icons.favorite_rounded,
                        label: '평균 심박',
                        value: '-',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.play_arrow_rounded,
                        label: '기록 시작',
                        onTap: () async {
                          await Navigator.pushNamed(context, Routes.record);
                          _refresh();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.search_rounded,
                        label: '루트 검색',
                        onTap: () {
                          Navigator.pushNamed(context, Routes.routes);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text('최근 루트', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),

                if (data.recent.isEmpty)
                  const Text('아직 저장된 루트가 없어요. 기록을 시작해보세요!')
                else
                  ...data.recent.indexed.map((e) {
                    final i = e.$1;
                    final r = e.$2;

                    return Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
                      child: Dismissible(
                        key: ValueKey('home_recent_${r.id}'),
                        direction: DismissDirection.endToStart,
                        background: _dismissBg(context),
                        confirmDismiss: (_) async {
                          final ok = await _confirmDelete(context, r.title);
                          if (ok != true) return false;

                          final repo = RepoRegistry.I.routeRepo;
                          final backup = r;
                          try {
                            await repo.delete(r.id);
                            if (!context.mounted) return false;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('루트를 삭제했습니다.'),
                                action: SnackBarAction(
                                  label: '되돌리기',
                                  onPressed: () async {
                                    await repo.create(backup);
                                  },
                                ),
                              ),
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('삭제 실패: $e')),
                              );
                            }
                          }
                          return false; // 스트림으로 새로고침되므로 원위치
                        },
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.routes),
                          borderRadius: BorderRadius.circular(12),
                          child: RecentRouteTile(
                            title: r.title,
                            meta: '${r.distanceText} · ${r.movingTimeText} · ${r.avgPaceText}',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _HomeBottomBar(
        onHome: () {},
        onRoutes: () => Navigator.pushNamed(context, Routes.routes),
        onStats: () => Navigator.pushNamed(context, Routes.stats),
        onSettings: () => Navigator.pushNamed(context, Routes.settings),
      ),
    );
  }

  Widget _dismissBg(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.delete_rounded, color: cs.onErrorContainer),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String title) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('삭제하시겠어요?'),
        content: Text('‘$title’ 루트를 삭제하면 복구할 수 없습니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          FilledButton.tonal(onPressed: () => Navigator.pop(ctx, true), child: const Text('삭제')),
        ],
      ),
    );
  }
}

class _HomeData {
  final RouteLog? latest;
  final double totalKm;
  final int durationMinutes;
  final double progress;
  final List<RouteLog> recent;

  const _HomeData({
    required this.latest,
    required this.totalKm,
    required this.durationMinutes,
    required this.progress,
    required this.recent,
  });

  const _HomeData.empty()
      : latest = null,
        totalKm = 0,
        durationMinutes = 0,
        progress = 0,
        recent = const [];
}

class _HomeBottomBar extends StatelessWidget {
  const _HomeBottomBar({
    required this.onHome,
    required this.onRoutes,
    required this.onStats,
    required this.onSettings,
  });

  final VoidCallback onHome;
  final VoidCallback onRoutes;
  final VoidCallback onStats;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              _navItem(context, Icons.home_rounded, '홈', selected: true, onTap: onHome, cs: cs, t: t),
              _navItem(context, Icons.route_rounded, '루트', selected: false, onTap: onRoutes, cs: cs, t: t),
              _navItem(context, Icons.query_stats, '통계', selected: false, onTap: onStats, cs: cs, t: t),
              _navItem(context, Icons.settings_rounded, '설정', selected: false, onTap: onSettings, cs: cs, t: t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      BuildContext context,
      IconData icon,
      String label, {
        required bool selected,
        required VoidCallback onTap,
        required ColorScheme cs,
        required TextTheme t,
      }) {
    final color = selected ? cs.primary : cs.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 2),
              Text(label, style: t.labelSmall?.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
