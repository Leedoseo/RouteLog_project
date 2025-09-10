import 'package:flutter/material.dart';
import 'package:routelog_project/features/home/widgets/widgets.dart';
import 'package:routelog_project/features/record/record_screen.dart';
import 'package:routelog_project/features/routes/routes_list_screen.dart';
import 'package:routelog_project/features/stats/stats_screen.dart';
import 'package:routelog_project/features/search/search_screen.dart';
import 'package:routelog_project/features/settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // 앱 타이틀 및 검색 기능(현재는 미구현 상태 추후 구현)
        title: const Text("RouteLog"),
        actions: [
          IconButton(
            tooltip: "검색",
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            tooltip: "설정",
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // 섹션 타이틀 : 오늘 요약 [거리, 시간 간단 타일]
                  SectionTitle("오늘 요약"),
                  SizedBox(height: 8),

                  // SummaryTile 2개 : 거리/시간 값 표시. 현재는 "--"로 고정
                  Row(
                    children: [
                      Expanded(child: SummaryTile(title: '거리', value: '-- km')), // 오늘 이동 거리
                      SizedBox(width: 8),
                      Expanded(child: SummaryTile(title: '시간', value: '-- m')), // 오늘 이동 시간
                    ],
                  ),

                  SizedBox(height: 20),
                  SectionTitle("빠른 동작"),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: QuickActionButton(
                      label: "기록 시작",
                      icon: Icons.play_arrow_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RecordScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: QuickActionButton(
                      label: "내 루트",
                      icon: Icons.route_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RoutesListScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: QuickActionButton(
                      label: "통계",
                      icon: Icons.insights_rounded,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const StatsScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 최근 루트 섹션 타이틀
          const SliverToBoxAdapter(child: SectionTitlePadding('최근 루트')),

          // 최근 루트 리스트 : RouteCard 3개 고정 목업. 실제 데이터 연결은 나중에.
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return RouteCard(
                  title: "루트 ${index + 1}", // 루트 이름/태그 요약 표시 예정
                  subtitle: "2025.09.03  -  --km  -  --m", // 날짜/거리/시간 메타 표시 예정
                  onTap: () => _notImplemented(context, "Route Detail 연결 예정"),
                );
              },
            ),
          ),
        ],
      ),

      // FAB: 기록 시작 플로우 진입. 현재는 스낵바만 띄움.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RecordScreen()),
          );
        },
        icon: const Icon(Icons.play_circle_fill_rounded),
        label: const Text("기록 시작"),
      ),
    );
  }
}

void _notImplemented(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}
