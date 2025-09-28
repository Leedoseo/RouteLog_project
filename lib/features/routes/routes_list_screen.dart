import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/features/routes/route_detail_screen.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('루트'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: '알림',
          ),
        ],
      ),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            const RouteSearchBar(),
            const SizedBox(height: 12),
            const FilterChipsBar(
              initial: FilterState(distance: true),
            ),
            const SizedBox(height: 16),

            Text('최근', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),

            // 목업 데이터 3개
            ...List.generate(3, (i) {
              return Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
                child: RouteListTile(
                  title: '강변 러닝 코스 ${i + 1}',
                  meta: '5.2km · 28분 · 5\'25"/km',
                  distanceText: '5.2km',
                  paceText: '5\'25"/km',
                  isFavorited: i == 0,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RouteDetailScreen(title: '강변 러닝 코스 ${i + 1}'),
                      ),
                    );
                  },
                  onExport: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('내보내기(목업)')));
                  },
                  onShare: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('공유(목업)')));
                  },
                  onDelete: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('삭제(목업)')));
                  },
                  onToggleFavorite: (fav) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(fav ? '즐겨찾기에 추가' : '즐겨찾기 해제')),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
