import 'package:flutter/material.dart';

class MonthPickerBar extends StatelessWidget {
  final DateTime month;
  final ValueChanged<DateTime> onChanged;
  final DateTime? minMonth;
  final DateTime? maxMonth;
  final bool showThisMonthButton; // 지금은 무시(단순 버전)

  const MonthPickerBar({
    super.key,
    required this.month,
    required this.onChanged,
    this.minMonth,
    this.maxMonth,
    this.showThisMonthButton = true,
  });

  DateTime _startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);
  DateTime _prevMonth(DateTime d) => DateTime(d.year, d.month - 1, 1);
  DateTime _nextMonth(DateTime d) => DateTime(d.year, d.month + 1, 1);

  bool _isBeforeMin(DateTime m) =>
      minMonth == null ? false : _startOfMonth(m).isBefore(_startOfMonth(minMonth!));
  bool _isAfterMax(DateTime m) =>
      maxMonth == null ? false : _startOfMonth(m).isAfter(_startOfMonth(maxMonth!));

  String _label(DateTime d) => "${d.year}.${d.month.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final m = _startOfMonth(month);
    final prev = _prevMonth(m);
    final next = _nextMonth(m);

    final prevDisabled = _isBeforeMin(prev);
    final nextDisabled = _isAfterMax(next);

    return SizedBox(
      height: 56, // 최소 높이 보장
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            // 이전 달
            IconButton(
              tooltip: '이전 달',
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: prevDisabled ? null : () => onChanged(prev), // ← 표준 비활성 처리
            ),
            // 라벨
            Expanded(
              child: Center(
                child: Text(
                  _label(m),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // 다음 달
            IconButton(
              tooltip: '다음 달',
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: nextDisabled ? null : () => onChanged(next), // ← 표준 비활성 처리
            ),
          ],
        ),
      ),
    );
  }
}
