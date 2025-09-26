import 'package:flutter/material.dart';
import 'package:routelog_project/core/decoration/app_background.dart';

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('오픈소스 라이선스')),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            // 안내 카드
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('라이브러리 목록', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    '여기는 앱에서 사용하는 오픈소스 라이브러리 목록이 표시되는 화면입니다. '
                        'Flutter 내장 라이선스 화면을 열 수도 있고, 커스텀 목록을 구성할 수도 있습니다.',
                    style: t.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.library_books_rounded),
                        label: const Text('Flutter 기본 보기'),
                        onPressed: () {
                          showLicensePage(
                            context: context,
                            applicationName: 'RouteLog',
                            applicationVersion: '0.1.0 (mock)',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 예시 라이선스 항목(목업)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('예시 라이브러리', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  _licenseTile(context, 'package_a', 'MIT'),
                  _licenseTile(context, 'package_b', 'BSD-3-Clause'),
                  _licenseTile(context, 'package_c', 'Apache-2.0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _licenseTile(BuildContext context, String name, String license) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.extension_rounded, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(name)),
          const SizedBox(width: 8),
          Text(license, style: TextStyle(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
