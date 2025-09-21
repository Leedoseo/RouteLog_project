import 'package:flutter/material.dart';

// 기록 완료 요약
Future<void> showRecordFinishSheet(
    BuildContext context, {
      String distanceText = '-- km',
      String durationText = '--:--',
      String paceText = '--:-- /km',
    }) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetCtx) => _RecordFinishSheet(
      distanceText: distanceText,
      durationText: durationText,
      paceText: paceText,
    ),
  );
}

class _RecordFinishSheet extends StatefulWidget {
  final String distanceText;
  final String durationText;
  final String paceText;

  const _RecordFinishSheet({
    required this.distanceText,
    required this.durationText,
    required this.paceText,
  });

  @override
  State<_RecordFinishSheet> createState() => _RecordFinishSheetState();
}

  class _RecordFinishSheetState extends State<_RecordFinishSheet> {
    final TextEditingController _memoCtrl = TextEditingController();

    @override
    void dispose() {
      _memoCtrl.dispose();
      super.dispose();
    }

    void _snack(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    @override
    Widget build(BuildContext context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      final cs = Theme.of(context).colorScheme;
      final sheetHeight = MediaQuery.of(context).size.height * 0.68;

      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: sheetHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 그랩 핸들
              const SizedBox(height: 8),
              Container(
                width: 44,
                height: 5,

                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 12),

              // 헤더
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "기록 요약",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: "닫기",
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 본문 스크롤
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 지도 썸네일 자리(플레이스 홀더)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [cs.primaryContainer, cs.secondaryContainer],
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.map_rounded, size: 48),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // KPI 3개 (거리/시간/페이스)
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              icon: Icons.route_rounded,
                              label: "거리",
                              value: widget.distanceText,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MetricCard(
                              icon: Icons.speed_rounded,
                              label: "페이스",
                              value: widget.paceText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 메모 입력
                      Text(
                        "메모",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _memoCtrl,
                        minLines: 2,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          hintText: "간단한 메모를 남겨보세요",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 하단 액션
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    // 삭제 (위험 액션)
                    SizedBox(
                      width: 100,
                      child: OutlinedButton(
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (dCtx) => AlertDialog(
                              title: const Text("기록을 삭제할까요?"),
                              content: const Text("이 작업은 되돌릴 수 없습니다."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(dCtx).pop(false),
                                  child: const Text("취소"),
                                ),
                                FilledButton.tonal(
                                  onPressed: () => Navigator.of(dCtx).pop(true),
                                  child: const Text("삭제"),
                                ),
                              ],
                            ),
                          );
                          if (ok == true) {
                            Navigator.of(context).pop(); // 시트 닫기
                            _snack("삭제는 나중에 연결");
                          }
                        },
                        child: const Text("삭제"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 빈 공간
                    const Spacer(),
                    // 저장
                    SizedBox(
                      width: 140,
                      child: FilledButton(
                        onPressed: () {
                          _snack("저장은 나중에 연결");
                          Navigator.of(context).pop(); // 시트 닫기
                        },
                        child: const Text("저장"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
/// 요약 수치 타일 (작은 카드)
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}