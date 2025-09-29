import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/home/widgets/home_hero_dashboard.dart';
import 'package:routelog_project/features/home/widgets/mini_stat.dart';
import 'package:routelog_project/features/home/widgets/quick_action_button.dart';
import 'package:routelog_project/features/home/widgets/recent_route_tile.dart';
import 'package:routelog_project/core/navigation/app_router.dart';

// 기존 direct push용 import 제거:
// import 'package:routelog_project/features/record/record_screen.dart';
// import 'package:routelog_project/features/routes/routes_list_screen.dart';
// import 'package:routelog_project/features/settings/settings_screen.dart';
// import 'package:routelog_project/features/stats/stats_screen.dart';
// import 'package:routelog_project/features/routes/route_export_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RouteLog'),
        actions: [
          IconButton(
            onPressed: () {
              // 알림 페이지가 있으면 여기서 pushNamed로 연결하면 됨
              // Navigator.pushNamed(context, Routes.notifications);
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const HomeHeroDashboard(durationMinutes: 25, progress: 0.62),
            const SizedBox(height: 16),

            // ── 오늘의 지표(세 타일 동일폭/고정높이)
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

            // ── 빠른 액션 (Named routes로 전환)
            Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.play_arrow_rounded,
                    label: '기록 시작',
                    onTap: () {
                      Navigator.pushNamed(context, Routes.record);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.search_rounded,
                    label: '루트 검색',
                    onTap: () {
                      // 검색 화면이 따로 있으면 Routes.search로, 현재는 루트 리스트로 이동 원하면 Routes.routes
                      // 필요에 따라 아래 한 줄을 Routes.search로 바꿔도 됨.
                      Navigator.pushNamed(context, Routes.routes);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── 최근 루트
            Text('최근 루트', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...List.generate(3, (i) {
              return Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
                child: RecentRouteTile(
                  title: '강변 러닝 코스 $i',
                  meta: '5.0km · 25분 · 5\'15"/km',
                  onTap: () {
                    // 실제라면 특정 id로 상세로 가는 게 자연스러움: Navigator.pushNamed(context, Routes.routeDetail(id))
                    // 지금은 더미라 목록으로 연결 유지
                    Navigator.pushNamed(context, Routes.routes);
                  },
                ),
              );
            }),
          ],
        ),
      ),

      // ── 하단 탭 (홈 탭은 NO-OP, 나머지는 Named routes)
      bottomNavigationBar: _HomeBottomBar(
        onHome: () {
          // 홈은 현재 화면이므로 아무 것도 하지 않음 (무한 푸시 방지)
        },
        onRoutes: () {
          Navigator.pushNamed(context, Routes.routes);
        },
        onStats: () {
          Navigator.pushNamed(context, Routes.stats);
        },
        onSettings: () {
          Navigator.pushNamed(context, Routes.settings);
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

// ── 임시 Export 페이지(없으면 삭제하고 showRouteExportSheet 사용)
class _RouteExportPageStub extends StatelessWidget {
  const _RouteExportPageStub();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내보내기')),
      body: const Center(child: Text('Export 화면(임시)')),
    );
  }
}
