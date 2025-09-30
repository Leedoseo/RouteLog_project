import 'package:flutter/material.dart';

/// 컨트롤러에 흔한 3상태(loading/error/ready)를 화면에 쉽게 반영하기 위한 래퍼.
/// childBuilder: 실제 데이터 UI
class AsyncView extends StatelessWidget {
  final bool loading;
  final Object? error;
  final Widget Function(BuildContext) childBuilder;
  final Widget? loadingView;
  final Widget? errorView;
  final EdgeInsets padding;

  const AsyncView({
    super.key,
    required this.loading,
    required this.error,
    required this.childBuilder,
    this.loadingView,
    this.errorView,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(padding: padding, child: loadingView ?? const _DefaultLoading());
    }
    if (error != null) {
      return Padding(
        padding: padding,
        child: errorView ?? _DefaultError(error: error!.toString()),
      );
    }
    return childBuilder(context);
  }
}

class _DefaultLoading extends StatelessWidget {
  const _DefaultLoading();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: List.generate(3, (i) => _SkeletonBar(color: cs.outlineVariant)).expand((w) sync* {
        yield w; yield const SizedBox(height: 12);
      }).toList()..removeLast(),
    );
  }
}

class _DefaultError extends StatelessWidget {
  final String error;
  const _DefaultError({required this.error});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: cs.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(child: Text(error, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  final Color color;
  const _SkeletonBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        minHeight: 16,
        backgroundColor: color.withOpacity(0.25),
        valueColor: AlwaysStoppedAnimation(color.withOpacity(0.55)),
      ),
    );
  }
}
