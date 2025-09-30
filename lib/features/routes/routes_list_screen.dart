import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';
import 'package:routelog_project/features/routes/route_detail_screen.dart';

import 'package:routelog_project/core/widgets/async_view.dart';
import 'package:routelog_project/core/widgets/empty_view.dart';
import 'package:routelog_project/core/widgets/error_view.dart';

class RoutesListScreen extends StatelessWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    // NOTE:
    // 컨트롤러 연동이 이미 되어 있다면 아래 3개 값만 컨트롤러에서 가져오세요.
    // 지금 파일은 컨트롤러 유무와 무관하게 "컴파일 안전" 하게 기본값으로 둡니다.
    final bool loading = false;
    final Object? error = null;
    // 기존 목업: 3개. 비어있는 상태를 보고 싶으면 0으로 테스트 가능.
    final int mockCount = 3;

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
        child: AsyncView(
          loading: loading,
          error: error,
          loadingView: const Center(child: CircularProgressIndicator()),
          errorView: ErrorView(
            message: "루트를 불러오지 못했어요.",
            onRetry: () {
              // 컨트롤러가 있다면 reload 호출
              // controller.reload();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('다시 시도(목업)')),
              );
            },
          ),
          childBuilder: (_) {
            if (mockCount == 0) {
              return const EmptyView(
                title: "저장된 루트가 없어요",
                message: "기록을 완료하거나, 가져오기를 사용해 추가해 보세요.",
                icon: Icons.route_rounded,
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                const RouteSearchBar(),
                const SizedBox(height: 12),
                const FilterChipsBar(initial: FilterState(distance: true)),
                const SizedBox(height: 16),

                Text('최근', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),

                // 목업 데이터 렌더
                ...List.generate(mockCount, (i) {
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
            );
          },
        ),
      ),
    );
  }
}
