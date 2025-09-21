import 'package:flutter/material.dart';

/// Skeleton(로딩 플레이스홀더) 공용 위젯들
/// - 외부 패키지 없이 간단한 Shimmer 효과 제공
/// - 리스트/슬리버 모두 지원
///
/// 사용 예:
///   // 타일형 + 높이 직접 지정
///   const SliverSkeletonList(itemCount: 10, itemHeight: 88);
///   // 카드형
///   const SliverSkeletonList.card(itemCount: 6);

/// 리스트 형태의 스켈레톤 (일반 위젯 트리용)
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final bool showTrailing; // 우측 작은 네모
  final bool dense;        // 간격/사이즈를 조금 줄인 버전
  final double? itemHeight; // 각 아이템 높이(타일 모드에서만 사용)

  const SkeletonList({
    super.key,
    this.itemCount = 8,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
    this.spacing = 12,
    this.showTrailing = true,
    this.dense = false,
    this.itemHeight,
  });

  /// 큰 썸네일 카드 형태
  const SkeletonList.card({
    super.key,
    this.itemCount = 3,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
    this.spacing = 12,
  })  : showTrailing = false,
        dense = false,
        itemHeight = null;

  bool get _isCardMode => showTrailing == false && dense == false && itemHeight == null;

  @override
  Widget build(BuildContext context) {
    if (_isCardMode) {
      // 카드 스켈레톤
      return Padding(
        padding: padding,
        child: Column(
          children: [
            for (int i = 0; i < itemCount; i++) ...[
              const _SkeletonCard(),
              if (i != itemCount - 1) SizedBox(height: spacing),
            ],
          ],
        ),
      );
    }

    // 리스트 타일 스켈레톤
    return Padding(
      padding: padding,
      child: Column(
        children: [
          for (int i = 0; i < itemCount; i++) ...[
            _SkeletonTile(
              showTrailing: showTrailing,
              dense: dense,
              tileHeight: itemHeight,
            ),
            if (i != itemCount - 1) SizedBox(height: spacing),
          ],
        ],
      ),
    );
  }
}

/// Sliver 버전 스켈레톤 (CustomScrollView 안에서 사용)
class SliverSkeletonList extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final bool cardMode;     // true면 큰 카드 형태
  final bool showTrailing; // 리스트 타일 모드에서만 유효
  final bool dense;
  final double? itemHeight; // 각 아이템 높이(타일 모드에서만 사용)

  const SliverSkeletonList({
    super.key,
    this.itemCount = 8,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
    this.spacing = 12,
    this.cardMode = false,
    this.showTrailing = true,
    this.dense = false,
    this.itemHeight,
  });

  /// 카드 전용 팩토리
  const SliverSkeletonList.card({
    super.key,
    this.itemCount = 3,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 16),
    this.spacing = 12,
  })  : cardMode = true,
        showTrailing = false,
        dense = false,
        itemHeight = null;

  @override
  Widget build(BuildContext context) {
    if (cardMode) {
      return SliverPadding(
        padding: padding,
        sliver: SliverList.separated(
          itemCount: itemCount,
          separatorBuilder: (_, __) => SizedBox(height: spacing),
          itemBuilder: (_, __) => const _SkeletonCard(),
        ),
      );
    }

    return SliverPadding(
      padding: padding,
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: spacing),
        itemBuilder: (_, __) => _SkeletonTile(
          showTrailing: showTrailing,
          dense: dense,
          tileHeight: itemHeight,
        ),
      ),
    );
  }
}

/// 리스트 타일 모양 스켈레톤
class _SkeletonTile extends StatelessWidget {
  final bool showTrailing;
  final bool dense;
  final double? tileHeight; // 아이템 높이

  const _SkeletonTile({
    required this.showTrailing,
    required this.dense,
    this.tileHeight,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 높이(밀도에 따라)
    final h = tileHeight ?? (dense ? 56.0 : 72.0);
    final leadingSize = h * 0.6;      // 원형 아이콘 크기
    final lineHeight1 = (h * 0.18).clamp(8.0, 16.0);
    final lineHeight2 = (h * 0.14).clamp(6.0, 14.0);

    return SizedBox(
      height: h,
      child: Row(
        children: [
          // Leading (원형)
          _Shimmer(
            child: Container(
              width: leadingSize,
              height: leadingSize,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 텍스트 라인
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 세로 가운데 정렬
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Shimmer(
                  child: Container(
                    height: lineHeight1,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: _boxDecoration(context),
                  ),
                ),
                const SizedBox(height: 8),
                _Shimmer(
                  child: Container(
                    height: lineHeight2,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: _boxDecoration(context),
                  ),
                ),
              ],
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: 12),
            _Shimmer(
              child: Container(
                width: 20,
                height: 20,
                decoration: _boxDecoration(context, radius: 6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 큰 카드(썸네일형) 스켈레톤
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Shimmer(
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                color: cs.surfaceContainerHighest,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Shimmer(
                  child: Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: _boxDecoration(context),
                  ),
                ),
                const SizedBox(height: 8),
                _Shimmer(
                  child: Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: _boxDecoration(context),
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

/// Shimmer 효과를 주는 래퍼(외부 패키지 없이 ShaderMask로 구현)
class _Shimmer extends StatefulWidget {
  final Widget child;
  const _Shimmer({required this.child});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surfaceVariant;

    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            final dx = rect.width * _c.value;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                base,
                highlight,
                base,
              ],
              stops: const [0.25, 0.5, 0.75],
              transform: GradientTranslation(dx),
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// 공통 박스 데코레이션(모서리/배경)
BoxDecoration _boxDecoration(BuildContext context, {double radius = 8}) {
  return BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(radius),
  );
}

/// LinearGradient에 간단 평행 이동을 적용하기 위한 Transform
class GradientTranslation extends GradientTransform {
  final double dx;
  const GradientTranslation(this.dx);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..translate(dx);
  }
}
