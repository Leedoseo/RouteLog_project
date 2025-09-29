import 'package:flutter/material.dart';

/// 상단 검색 입력 위젯
/// - [initialText]: 초기 텍스트(옵션)
/// - [onSubmitted]: 엔터/돋보기 버튼 탭 시 콜백(옵션)
class RouteSearchBar extends StatefulWidget {
  const RouteSearchBar({
    super.key,
    this.initialText,
    this.onSubmitted,
  });

  final String? initialText;
  final ValueChanged<String>? onSubmitted;

  @override
  State<RouteSearchBar> createState() => _RouteSearchBarState();
}

class _RouteSearchBarState extends State<RouteSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void didUpdateWidget(covariant RouteSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부에서 query가 바뀐 경우 입력창도 동기화
    if (oldWidget.initialText != widget.initialText &&
        (widget.initialText ?? '') != _controller.text) {
      _controller.text = widget.initialText ?? '';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final k = _controller.text.trim();
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(k);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        hintText: '루트 검색…',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(
          tooltip: '검색',
          onPressed: _submit,
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    );
  }
}
