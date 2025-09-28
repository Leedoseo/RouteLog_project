import 'package:flutter/material.dart';
import 'package:routelog_project/core/widgets/skeleton_list.dart';
import 'package:routelog_project/core/widgets/empty_state.dart';
import 'package:routelog_project/features/home/widgets/recent_route_tile.dart';

import 'package:routelog_project/core/data/firebase_repository.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});
  static const routeName = "/routes";

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("루트 목록"),
        actions: [
          IconButton(
            tooltip: "샘플 추가",
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              await FirebaseRepository.instance.addMockRoute(
                title: "강변 러닝 코스",
                distanceKm: 5.0,
                meta: "5.0km · 25분 · 5'15\"/km",
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("샘플 루트를 추가했어요")),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          Text("내 루트", style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),

          // Firestore 바인딩
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: FirebaseRepository.instance.routesStream(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SkeletonList(itemCount: 6, dense: true);
              }
              if (!snap.hasData) {
                return const SkeletonList(itemCount: 6, dense: true);
              }
              final routes = snap.data!;
              if (routes.isEmpty) {
                return EmptyState(
                  icon: Icons.route_rounded,
                  title: "저장된 루트가 없어요",
                  message: "샘플을 추가해보세요.",
                  actionLabel: "샘플 추가",
                  onAction: () {
                    FirebaseRepository.instance.addMockRoute(
                      title: "강변 러닝 코스",
                      distanceKm: 5.0,
                      meta: "5.0km · 25분 · 5'15\"/km",
                    );
                  },
                );
              }

              return Column(
                children: [
                  for (final r in routes) ...[
                    RecentRouteTile(
                      title: r['title'] ?? '제목 없음',
                      meta: r['meta'] ??
                          '${(r['distanceKm'] ?? 0).toStringAsFixed(1)}km',
                      onTap: () {
                        // 상세로 이동 예정 (나중에 연결)
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
