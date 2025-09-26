import 'package:flutter/material.dart';

enum Period { week, month, all }

class PeriodTabs extends StatelessWidget {
  const PeriodTabs({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Period value;
  final ValueChanged<Period> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget tab(String label, Period p) {
      final selected = value == p;

      return Expanded(
        child: Material(
          color: selected ? cs.surface : cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.outlineVariant),
          ),
          child: InkWell(
            onTap: () => onChanged(p),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  label,
                  style: t.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected ? cs.primary : t.labelLarge?.color,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab("주", Period.week),
        const SizedBox(width: 8),
        tab("월", Period.month),
        const SizedBox(width: 8),
        tab("전체", Period.all),
      ],
    );
  }
}