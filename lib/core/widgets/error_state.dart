import 'package:flutter/material.dart';
/// ErrorState
/// - 오류(네트워크 실패, 권한 거부, 내부 예외 등) 상황을 공통으로 보여주는 위젯
/// - EmptyState와 페어로 사용. 메시지 + (선택) 액션 버튼 1~2개 제공.

class ErrorState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final double topSpacing;

  const ErrorState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.topSpacing = 32,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, topSpacing, 24, 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 아이콘 배지
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Icon(icon, size: 40, color: cs.onErrorContainer),
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

              // 액션
              if (actionLabel != null || secondaryActionLabel != null) ...[
                const SizedBox(height: 16),
                if (actionLabel != null && secondaryActionLabel != null)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onSecondaryAction,
                          child: Text(secondaryActionLabel!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: onAction,
                          child: Text(actionLabel!),
                        ),
                      ),
                    ],
                  )
                else if (actionLabel != null)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onAction,
                      child: Text(actionLabel!),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onSecondaryAction,
                      child: Text(secondaryActionLabel!),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
