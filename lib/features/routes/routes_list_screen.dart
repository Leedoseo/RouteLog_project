import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/route_detail_screen.dart';
import 'package:routelog_project/features/search/search_screen.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockItems = List.generate(10, (i) => "루트 ${i + 1}"); // 10개짜리 더미 리스트 생성

    return Scaffold(
      appBar: AppBar(
        title: const Text("내 루트"),
        actions: [
          IconButton(
            tooltip: "검색(미구현)",
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 상단 필터/정렬 바
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: RoutesFilterBar(
                onSortTap: () => _notImplemented(context, "정렬 바텀시트 예정"),
                onFilterTap: () => _notImplemented(context, "필터 바텀시트 예정"),
                onTagTap: () => _notImplemented(context, "태그 선택 예정"),
              ),
            ),
          ),

          // 리스트 섹션 타이틀
          const SliverToBoxAdapter(
            child: SectionTitlePadding("전체 루트"),
          ),

          // 루트 카드 리스트
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemCount: mockItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final title =mockItems[index];
                return RouteListCard(
                  title: title,
                  // 메타 텍스트는 목업, 나중에 거리/시간/태그로 대체
                  subtitle: "2025.09.03  -  --km  -  --m  -  #산책",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RouteDetailScreen()),
                    );
                  },
                  onMoreTap: () => _notImplemented(context, "더보기 액션 예정"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _notImplemented(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}