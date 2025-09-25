import 'package:flutter/material.dart';

class FilterState {
  const FilterState({this.distance = false, this.tags = false, this.sort = false});
  final bool distance;
  final bool tags;
  final bool sort;

  FilterState copyWith({bool? distance, bool? tags, bool? sort}) {
    return FilterState(
      distance: distance ?? this.distance,
      tags: tags ?? this.tags,
      sort: sort ?? this.sort,
    );
  }
}

class FilterChipsBar extends StatefulWidget {
  const FilterChipsBar({super.key, this.initial = const FilterState()});

  final FilterState initial;

  @override
  State<FilterChipsBar> createState() => _FilterChipsBarState();
}

class _FilterChipsBarState extends State<FilterChipsBar> {
  late FilterState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget chip({
      required String label,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Material(
        color: selected ? cs.surface : cs.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: cs.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Icon(Icons.check_rounded, size: 18, color: cs.primary),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: t.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected ? cs.primary : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip(
          label: '거리',
          selected: _state.distance,
          onTap: () => setState(() => _state = _state.copyWith(distance: !_state.distance)),
        ),
        chip(
          label: '태그',
          selected: _state.tags,
          onTap: () => setState(() => _state = _state.copyWith(tags: !_state.tags)),
        ),
        chip(
          label: '정렬',
          selected: _state.sort,
          onTap: () => setState(() => _state = _state.copyWith(sort: !_state.sort)),
        ),
      ],
    );
  }
}
