import 'package:flutter/material.dart';

/// EmptyState
/// - 데이터가 없을 때 중앙에 아이콘/제목/설명/액션 버튼을 보여주는 공용 위젯
/// - 어디서든 재사용 가능 (홈, 목록, 검색 결과 없음, 통계 비어있음 등)

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double topSpacing;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    this.onAction,
    this.topSpacing = 32,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: SingleChildScrollView( // 작은 화면/키보드 대응
        padding: EdgeInsets.fromLTRB(24, topSpacing, 24, 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420), // 넓은 화면에서 과도한 확장 방지
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 아이콘 배지
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.onSurfaceVariant),
                ),
                child: Icon(icon, size: 40, color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 16),

              // 제목
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              // 설명
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85),
                  ),
                ),
              ],

              // 액션 버튼
              if (actionLabel != null) ...[
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}