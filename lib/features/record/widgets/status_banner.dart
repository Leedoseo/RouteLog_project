import 'package:flutter/material.dart';

/// Record 화면 상단에 표시하는 경고/안내 배너 (UI 목업)

class StatusBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onTap;
  final _StatusBannerStyle _style;

  const StatusBanner._({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onTap,
    required _StatusBannerStyle style,
  }) : _style = style;

  /// 정보성(파란톤)
  factory StatusBanner.info({
    Key? key,
    required String title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onTap,
    IconData icon = Icons.info_outline_rounded,
  }) {
    return StatusBanner._(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      actionLabel: actionLabel,
      onTap: onTap,
      style: _StatusBannerStyle.info,
    );
  }

  /// 경고(주황톤)
  factory StatusBanner.warning({
    Key? key,
    required String title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onTap,
    IconData icon = Icons.warning_amber_rounded,
  }) {
    return StatusBanner._(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      actionLabel: actionLabel,
      onTap: onTap,
      style: _StatusBannerStyle.warning,
    );
  }
  /// 오류(빨간톤)
  factory StatusBanner.error({
    Key? key,
    required String title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onTap,
    IconData icon = Icons.error_outline_rounded,
  }) {
    return StatusBanner._(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      actionLabel: actionLabel,
      onTap: onTap,
      style: _StatusBannerStyle.error,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    
    // 톤(배경/테두리/아이콘색) 결정
    final bg = switch (_style) {
      _StatusBannerStyle.info => cs.primaryContainer,
      _StatusBannerStyle.warning => cs.tertiaryContainer,
      _StatusBannerStyle.error => cs.errorContainer,
    };
    final border = cs.outlineVariant;
    final iconColor = switch (_style) {
      _StatusBannerStyle.info => cs.onPrimaryContainer,
      _StatusBannerStyle.warning => cs.onTertiaryContainer,
      _StatusBannerStyle.error => cs.onErrorContainer,
    };
    final textColor = iconColor;
    
    final bodySmall = theme.textTheme.bodySmall?.copyWith(color: textColor.withOpacity(0.9));
    final titleStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: textColor,
    );

    Widget inner = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  title,
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                    subtitle!,
                    style: bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onTap != null) ...[
          const SizedBox(width: 8),
          TextButton(
            onPressed: onTap,
            child: Text(actionLabel!),
          ),
        ],
      ],
    );

    // 전체를 탭 가능하게
    if (onTap != null && (actionLabel == null)) {
      inner = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: inner,
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: inner,
    );
  }
}

enum _StatusBannerStyle { info, warning, error }