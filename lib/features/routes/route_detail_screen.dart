import 'package:flutter/material.dart';
import 'package:routelog_project/features/routes/edit_note_sheet.dart';
import 'package:routelog_project/features/routes/widgets/widgets.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 목업용 더미 데이터
    const title = "한강 러닝 코스";
    const dateText = "2025.09.03 (수)";
    const distanceText = "5.20km";
    const durationText = "28:12";
    const paceText = "5:25 /km";
    const tags = <String>["러닝", "산책", "퇴근길"];
    const memo = "가을 바람 불어서 컨디션 좋았음. 반포대교 구간 혼잡.";

    return Scaffold(
      appBar: AppBar(
        title: const Text("루트 상세"),
        actions: [
          IconButton(
            tooltip: '편집(미구현)',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showEditNoteSheet(
              context,
              initialText: memo, // 기존 메모 넘기기(옵션)
            ),
          ),
          IconButton(
            tooltip: "공유(미구현)",
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => _notImplemented(context, "공유는 나중에 연결"),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 상단 미니맵
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(child: MapMiniPlaceholder(title: title)),

          // 메타 행
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: MetaRow(
                dateText: dateText,
                distanceText: distanceText,
                durationText: durationText,
                paceText: paceText,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 태그 섹션
          const SliverToBoxAdapter(child: SectionTitlePadding("태그")),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (final t in tags) TagChip(label: "#$t")],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height:20)),

          // 사진 섹션
          const SliverToBoxAdapter(child: SectionTitlePadding("사진")),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PhotoGrid(
                count: 4, // 0~6에서 테스트
                onTap: (i) => _notImplemented(context, "사진 뷰어는 나중에 연결"),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 메모 섹션
          const SliverToBoxAdapter(child: SectionTitlePadding("메모")),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: MemoCard(
                text: memo,
                onEditTap: () => showEditNoteSheet(
                  context,
                  initialText: memo,
                ),
              ),
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