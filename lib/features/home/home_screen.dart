import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/home/widgets/home_hero_dashboard.dart';
import 'package:routelog_project/features/home/widgets/mini_stat.dart';
import 'package:routelog_project/features/home/widgets/quick_action_button.dart';
import 'package:routelog_project/features/home/widgets/recent_route_tile.dart';

import 'package:routelog_project/features/record/record_screen.dart';
import 'package:routelog_project/features/routes/routes_list_screen.dart';
import 'package:routelog_project/features/settings/settings_screen.dart';
import 'package:routelog_project/features/stats/stats_screen.dart';

import 'package:routelog_project/core/widgets/async_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    // 컨트롤러가 붙으면 실제 값으로 교체
    final bool loading = false;
    final Object? error = null;

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
        child: AsyncView(
          loading: loading,
          error: error,
          childBuilder: (_) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                const HomeHeroDashboard(durationMinutes: 25, progress: 0.62),
                const SizedBox(height: 16),

                Row(
                  children: const [
                    Expanded(child: MiniStat(icon: Icons.timer_outlined, label: '세션 시간', value: '00:25:12')),
                    SizedBox(width: 12),
                    Expanded(child: MiniStat(icon: Icons.directions_run_rounded, label: '누적 거리', value: '5.0 km')),
                    SizedBox(width: 12),
                    Expanded(child: MiniStat(icon: Icons.favorite_rounded, label: '평균 심박', value: '148 bpm')),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.play_arrow_rounded,
                        label: '기록 시작',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RecordScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionButton(
                        icon: Icons.search_rounded,
                        label: '루트 검색',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RoutesListScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text('최근 루트', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...List.generate(3, (i) {
                  return Padding(
                    padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
                    child: RecentRouteTile(
                      title: '강변 러닝 코스 $i',
                      meta: '5.0km · 25분 · 5\'15"/km',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RoutesListScreen()),
                        );
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: _HomeBottomBar(
        onHome: () {},
        onRoutes: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RoutesListScreen()));
        },
        onStats: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StatsScreen()));
        },
        onSettings: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
        },
      ),
    );
  }
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
              _navItem(context, Icons.home_rounded, '홈', selected: true,  onTap: onHome,    cs: cs, t: t),
              _navItem(context, Icons.route_rounded, '루트', selected: false, onTap: onRoutes, cs: cs, t: t),
              _navItem(context, Icons.query_stats,  '통계', selected: false, onTap: onStats,  cs: cs, t: t),
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
