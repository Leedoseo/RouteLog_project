import 'package:flutter/material.dart';
import 'package:routelog_project/features/record/widgets/widgets.dart';

/// 기록 종료 후 요약화면(목업)

class RecordFinishScreen extends StatefulWidget {
  const RecordFinishScreen({super.key});

  static const routeName = "/record/finish";

  @override
  State<RecordFinishScreen> createState() => _RecordFinishScreenState();
}

class _RecordFinishScreenState extends State<RecordFinishScreen> {
  final TextEditingController _memo = TextEditingController(text: "");

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _memo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 목업용 더미값
    const dateText = "2025.09.15 (월)";
    const distanceText = "5.20 km";
    const durationText = "28.12";
    const paceText = "5:25 /km";

    return Scaffold(
      appBar: AppBar(
        title: const Text("기록 요약"),
        actions: [
          IconButton(
            tooltip: "삭제(미구현)",
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _snack("삭제는 나중에 연결"),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // 지도 썸네일(플레이스 홀더)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: MetricsPanel(
                distanceText: distanceText,
                durationText: durationText,
                paceText: paceText,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 날짜/메타 간단 표기
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.event_rounded),
                  const SizedBox(width: 8),
                  Text(dateText, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 메모 입력
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _memo,
                minLines: 3,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: "메모(선택)",
                  hintText: "러닝 소감이나 컨디션을 기록해두세요",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // 액션 버튼
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _snack("취소 삭제는 나중에 연결");
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close_rounded),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("취소"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        _snack("저장은 나중에 연결 (메모: ${_memo.text})");
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("저장"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}